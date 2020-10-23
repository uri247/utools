import os
import re

search_path = os.environ['PATH'].split(';')
nocyg_search_path = [p for p in search_path if re.search('cygwin', p) is None]
print(f"set PATH={';'.join(nocyg_search_path)}")

