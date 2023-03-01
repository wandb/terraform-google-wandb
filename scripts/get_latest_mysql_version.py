import requests
import re
import os
from packaging import version


URL: str = 'https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion'


if __name__ == "__main__":
    results = requests.get(URL, timeout=30).text

    versions = re.findall(r'MYSQL\w*', results)
    sem_ver = set(s.replace('MYSQL_', '').replace('_', '.') for s in versions)

    latest_version = sorted(sem_ver, key=version.Version)
    latest_version.reverse()

    latest = f"MYSQL_{latest_version[0].replace('.', '_')}"

    if os.getenv("GITHUB_ACTIONS") == "true":
        print(f'::set-output name=LATEST_VERSION::{latest}')
    else:
        print(latest)

