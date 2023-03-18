import re
from time import sleep
import urllib.parse

from pydrive2.auth import GoogleAuth
from pydrive2.drive import GoogleDrive


def get_code():
    extract_code = re.compile(r"\?code=(.*)&")
    with open("/tmp/nc_output") as fd:
        while True:
            line = fd.readline()
            if match := extract_code.search(line):
                return urllib.parse.unquote(match.group(1))
            sleep(1)


def print_hi():
    gauth = GoogleAuth()
    auth_url = gauth.GetAuthUrl()
    print(f"Please open in your browser: {auth_url}")
    code = get_code()

    gauth.Auth(code)
    drive = GoogleDrive(gauth)

    file_list = drive.ListFile({'q': "'root' in parents and trashed=false"}).GetList()
    for file1 in file_list:
        print('title: %s, id: %s' % (file1['title'], file1['id']))


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print_hi()

