Version française ici [README.md](README.md).

# Lab: Study of a vulnerable program in Python (Web Application)

During this lab, your are going to study a minimalist web application
which is vulnerable to an SQL injection.

Prerequisite are:
 * A Linux PC with Python 3
 * An access to a MySQL server (on your machine, or elsewhere, no matter)
 * Being able to program in Python
 * Knowing the basis of HTML, javascript and SQL
 * Having watched the lesson on SQL injection

You can use your OpenStack machine, as in the last subject on UNIX permissions.
You can also use the OVA image available at: https://nextcloud.univ-lille.fr/index.php/s/BMawwN5m8AcT9oJ

## Preparation

In this repository, you will find the file `serveur.py` which contains the python source code of the vulnerable server.

### Preparation of a Python3 virtual environment

A Python3 virtual environment is a kind of independent installation and self-sufficient of Python3, which will be placed in your personal folder, and in which you can install Python3 module without needing root rights, and without touching the rest of the system.

If you work with your own machine, be sure to have properly installed the virtual environment creation tool (on Ubuntu/Debian: `sudo apt install python3-venv`).

Then, prepare the virtual environment with the following command (where `<folder name>` should be replaced by the folder name that will contain your virtual environment).

```
python3 -m venv <folder name>
```

For example: `python3 -m venv myLabEnv`

### Virtual environment activation

To work with the virtual environment that you have prepare, you need first to activate it using the following command:

```
source <path to your virtual environment>/bin/activate
```

For example: `source myLabEnv/bin/activate`

This activation persists only during the ongoing shell/terminal session, and should be re-done if you disconnect, or if you relaunch a terminal. To known if the virtual environment is activated, you can verify that its name appears, in parenthesis, in you shell prompt.

For now on, all steps that should be realised in this lab (including the next preparation steps) requires the virtual environment to be activated.

### Required Python3 modules installation

Install required modules in your environment (don't forget that it needs to be activated) by executing the following commands:

```
pip3 install cherrypy
pip3 install mysql-connector-python
```

The module `cherrypy` is a Web application framework in python, the module `mysql-connector-python` allows to connect to a MySQL base.

### MySQL table creation

To create the table that will be used by the application, connect to your MySQL database with your favorite tool, and create the following table:

```
CREATE TABLE chaines (
	id int NOT NULL AUTO_INCREMENT, 
	txt varchar(255) not null, 
	who varchar(255) not null,
	PRIMARY KEY(id)
);
```

### Configuration of the database access

Rename (or copy) the database configuration file `config.py.sample` to `config.py` and edit it to add the information for accessing to your MySQL datatbase.

Given that the file `config.py` contains your MySQL server password, be careful not to commit it on your git repository (you can, for example, add it to the `.gitignore`).

## Work to be done

### Getting to known with the application

Launch the application with the following command (being in the git repository folder, and with the virtual environment activated):

```
./serveur.py
```

The common errors that you may encounter while launching the server are:
 * File `serveur.py` not found: verify that your are well placed in the git repository folder.
 * Modules not found (cherrypy or mysql connector): be sure that the virtual environment is activated
 * Connection problem to the database: verify that the given informations in `config.py` are correct
 * Port 8080 already in used: verify that an other server is not already listening the port 8080 (potentially an other instance of `serveur.py` launched in an other terminal)

If it works, you will have a line like:
```
[03/Dec/2020:13:10:03] ENGINE Serving on http://127.0.0.1:8080
```

You need to keep this terminal opened during all the server usage. To stop it, type Ctrl-C in the terminal you launched it.

Next, go to `http://localhost:8080` with your web browser, and test the page operation. Especially:
 * Test the data addition using the form, and verify that the data is added in the database
 * Look the source code of the web page
 * Look the source code of the program serveur.py 

The application allows to add strings in a table of the database (in the column txt), while logging the IP address of the string sender (in the column who)

You can look the CherryPy documentation at https://cherrypy.org/ and the python MySQL connector documentation at https://dev.mysql.com/doc/connector-python/en/

### Find a first vulnerability (SQL injection)

Remainder: the SQL injection vulnerability happens when an SQL requests is build non-securely, for example by concatenating strings, using elements given by a potential malicious user.

Thus, if we suppose that a request built as follows, even though the variable `value` is controlled by the used
```
request = "SELECT * FROM table WHERE champ='" + value "';"
```

If the value given by the user is: `'; <other SQL command>; --`, then
the request variable will have the following value: `SELECT * FROM table WHERE champ=''; <other SQL command>;
--';` and the other SQL command will be executed.

Without adding a second command to execute, it is possible to modify the SQL request to perform non-indented behavior.

For example, if the value given by the user is `' OR 1=1 --`, then
the SQL request will be: `SELECT * FROM table WHERE champ='' OR 1=1`, which will return all the data of the table.

Look at the `serveur.py` source code to find an SQL injection vulnerability. For helping purposes, you can also print the MySQL request by adding a `print(request)` in the method `index`.

Look the web page source code from your web browser. A mechanism has been setup to try to avoid the vulnerability exploitation.

#### Question 1
Answer the following questions:
 * What is this mechanism?
 * Is it effective? Why?

#### Question 2: Bypassing validation mechanism

Using the tool `curl`, propose a command that allows to send the form data to the server without passing through the validation. You can use the development tools of your browser, which allows to create automatically a `curl` command line from an http request: https://ec.haxx.se/usingcurl/usingcurl-copyas

Try to insert in the database some strings that contains characters that are forbidden by the validation, and verify that they are well inserted in the table.

#### Question 3: Vulnerability exploitation

Using `curl`, and after reading the SQL injection lesson if needed, realise an SQL injection that insert a string in the database and is able to choose the content of the filed `who` (insert something different than your IP address). Check that it works properly.

SQL injections exploitation is not limited to data destruction. Assuming that an other table exists in the database, imagine a way to use this SQL injection to obtain information on the data stored on the other table (it is not required to implement it, but explain a possible approach)

#### Question 4: Patching the vulnerable application

* Correct the security flaw in the application. You can read https://pynative.com/python-mysql-execute-parameterized-query-using-prepared-statement/ to have an idea on how to do it.
* Try again the flaw exploitation developed earlier, check that the application is no longer vulnerable.

### Find an other vulnerability (XSS)

Remainder: ab XSS flaw happens when a potential malicious user can inject HTML tags in a page, that will be interpreted by the web browser.

If a web service sends a page whose content is stored in this string variable:
```
page_content = "<p> Hello, " + name + "</p>"
```
 If a malicious user can control the content of the variable `name`, then it can add HTML tags, that will be interpreted by the browser. That constitutes a security flaw, because one of theses tags is the tag `<script>`, which allows to execute javascript code on the browser. This javascript code can then perform malicious actions, such as session cookie stealing ...

Look at `server.py` to find an XSS vulnerability.

#### Question 5: XSS flaw exploitation

* First, using `curl` inject a script tag that print a dialog box on the screen of the visiting user. For information, the javascript syntax is: `alert('Hello!')`

* The, using `curl` exploit the XSS flaw that allows to steal the cookies of users that visit the page.

TO do this, a possible way is write a javascript code that modifies `document.location`, to redirect victims to the URL of a server you control, such that the content of the request contains the informations useful to steal.
You can find needed information here:
https://developer.mozilla.org/fr/docs/Web/API/Document/location

You can simulate a server to retrieve the information stolen using the following command:

```
nc -l -p <port number>
```

Thus, if someone goes to the URL `http://<your IP>:<port number>`, the full request will be printed by `nc` (be careful, it only works one time, you need to relaunch the nc command before each new try)

#### Question 6: Patching the flaw

Correct the XSS flaw in the file `server.py`, you can for example use
the `escape` function of the `html` python module.

Where this processing should be? At the database insertion time, at
the printing time, both?  Why?

Try again the flaw exploitation developed earlier, and verify that the application is no longer vulnerable.
