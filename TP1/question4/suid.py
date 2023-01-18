import os 
def imprime_uid():
    print("RUID: ", os.getuid())
    print("EUID: ", os.geteuid())
    print("RGID: ", os.getgid())
    print("EGID: ", os.getegid())

if __name__ == "__main__":
    imprime_uid()
