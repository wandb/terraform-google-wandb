import os
import re
import requests

from packaging import version


URL: str = 'https://cloud.google.com/sql/docs/mysql/admin-api/rest/v1beta4/SqlDatabaseVersion'


def is_version_compatible(v: str) -> bool:
    return re.match(r'^MYSQL_(8|5)', v)


if __name__ == "__main__":
    results = requests.get(URL, timeout=30).text

    versions = re.findall(r'MYSQL\w*', results)
    compatible_versions = filter(is_version_compatible, versions)
    sem_ver = set(s.replace('MYSQL_', '').replace('_', '.') for s in compatible_versions)
    
    print(sem_ver)

    latest_version = sorted(sem_ver, key=version.Version)
    latest_version.reverse()

    latest = f"MYSQL_{latest_version[0].replace('.', '_')}"

    if os.getenv("GITHUB_ACTIONS") == "true":
        print(f'::set-output name=LATEST_VERSION::{latest}')
    else:
        print(latest)

