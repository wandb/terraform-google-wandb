import re
import sys

def set_variable_default(variable: str, value: str, content: str) -> str:
    """
    This script uses regex to replace the text. It makes an assumption that the
    default value must be declared before an conditions are applied.
    """
    pat = '(variable\s+\"' + variable + '\"\s*{[^\}]+\s+default\s*=\s\").*(\"\n)'
    # pat = '(variable\s+\"' + variable + '\"\s*{[\s\S]+\s+default\s+=\s\").*(\"[\s\S]+}\n\n)'
    # pat = '(variable\s*\"' + variable + '\"\s*{[\s\w\"=.#]*default\s*=\s\").*(\"[\w\s\{=\(\)\[\]\",\.;:\\\}]*}\n\n)'
    # pat = '(variable\ \"' + variable + '\"\ {[\s\w\"=.#]+default\s*=\s\")[\w\s\d]*(\"[\s\w\"]*})'
    return re.sub(
        pat,
        r'\1' + value + r'\2',
        content
    )


if __name__ == '__main__':
    var, val, *var_file = sys.argv[1:]
    file_path = ''.join(var_file) or 'variables.tf'

    print(f"Setting \"{var}\" to \"{val}\" in \"{file_path}\"")

    with open(file_path, 'r+', encoding="utf8") as f:
        txt = f.read()
        result = set_variable_default(var, val, txt)
        f.seek(0)
        f.write(result)
