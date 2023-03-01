import re
import sys


def set_variable_default(variable: str, value: str, content: str) -> str:
    """Parses variable and replaces default value"""
    pat = '(variable\ \"' + variable + '\"\ {[\s\w\"=.#]+default\s*=\s\")[\w\s\d]*(\"[\s\w\"]*})'
    return re.sub(
        pat,
        r'\1' + value + r'\2',
        content
    )


if __name__ == '__main__':
    var, val, *var_file = sys.argv[1:]
    file_path = ''.join(var_file) or 'variables.tf'
    print(var_file)

    print(f"Setting \"{var}\" to \"{val}\" in \"{file_path}\"")

    with open(file_path, 'r+', encoding="utf8") as f:
        txt = f.read()
        result = set_variable_default(var, val, txt)
        f.seek(0)
        f.write(result)
