import os
import time

def is_successful(result):
        if(result == 0):   
                print("success")                                               
        else:                                                                  
                print("fail")
        return

def main():
        while(True):
                exit_status = os.system('/unit_tests/memtool -32 0x32EC0004=0x1FFFFF3')
                is_successful(exit_status)
                time.sleep(0.033)
                exit_status = os.system('/unit_tests/memtool -32 0x32EC0004=0x1FFFFFF')
                is_successful(exit_status)
                time.sleep(0.033)


if __name__ == "__main__":
        main()
