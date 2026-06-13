import os
import glob
import re

jsp_dir = r"c:\Users\dell\IdeaProjects\ihwtrepo\src\main\webapp\WEB-INF\jsp"
count = 0

for root, dirs, files in os.walk(jsp_dir):
    for file in files:
        if file.endswith(".jsp"):
            filepath = os.path.join(root, file)
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
            
            # Use regex to find and remove placeholder="..."
            new_content, num_subs = re.subn(r'\s*placeholder="[^"]*"', '', content)
            
            if num_subs > 0:
                with open(filepath, "w", encoding="utf-8") as f:
                    f.write(new_content)
                count += num_subs
                print(f"Removed {num_subs} placeholders in {filepath}")

print(f"Total placeholders removed: {count}")
