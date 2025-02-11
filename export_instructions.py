import re
import os

def delete_file(file_path):
    try:
        os.remove(file_path)
        print(f"File {file_path} has been deleted successfully.")
    except FileNotFoundError:
        print(f"File {file_path} not found.")
    except Exception as e:
        print(f"An error occurred while deleting the file: {e}")

delete_file("./instructions-short.md")

def extract_chapter(file_path, chapter_title):
    """
    Extracts the content of a specific chapter from a Markdown file.
    """
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Regex to find the chapter based on its header
    # Matches content starting from the chapter header to the next header or the end of the file
    pattern = rf"({re.escape(chapter_title)}\b.*?)(?=\n# |$)"
    match = re.search(pattern, content, re.DOTALL)
    
    if match:
        return match.group(1)
    return None


def replace_links(content):
    """
    Replaces occurrences of '](' within specific link patterns,
    but only in content that contains specific keywords:
        macros](
        sheet](
        folder](
        czmac](
        ```](
    
    These keywords that are used for md preview won't be affected:
        pic](
        video](
        ring](#
        GUI](#
        port](#

    These keywords that already provide external links won't be affected:
        application](
        Arduino IDE](
        AccelStepper](
        ArduCAM](
    """
    
    modify_keywords = ["macros](", "sheet](", "folder](", "czmac](", "```]("]
    ignore_keywords = ["pic](", "video](", "ring](#", "GUI](#", "port](#",
        "application](", "Arduino IDE](", "AccelStepper](", "ArduCAM]("]

    def replacement_match(match):
        line = match.group(0)
        # If the line contains an ignore keyword or an external link, return it unchanged
        if any(keyword in line for keyword in ignore_keywords):
            return line
        # Check if the line already contains an external link (http:// or https://)
        if "http://" in line or "https://" in line or "github.com" in line:
            return line
        # If the line contains a modify keyword, replace `](` with the GitHub URL
        if any(keyword in line for keyword in modify_keywords):
            return line.replace('](', '](https://github.com/osvobo/iCAT/tree/dev/')
        return line  # Default case: leave it unchanged

    # Updated regex to ensure that links containing the modify keywords are also matched
    return re.sub(r'\[.*?\]\(.*?\)', replacement_match, content)


def append_to_file(target_path, content):
    """
    Appends the extracted and modified content to another Markdown file.
    """
    with open(target_path, 'a', encoding='utf-8') as file:
        file.write(content)
        #file.write("\n\n")  # Add spacing before the new content

def main():
    source_file = "./README.md"  # Path to the source Markdown file
    target_file = "./instructions-short.md"  # Path to the target Markdown file
    chapters_to_extract = [
        "# iCAT: A Multifunctional Open-Source Platform for Advanced Light Microscopy", 
        "## Supplies"
    ]  # List of chapters to extract
    
    for chapter_title in chapters_to_extract:
        print(f"Extracting '{chapter_title}'...")
        chapter_content = extract_chapter(source_file, chapter_title)
        if chapter_content:
            print(f"Replacing links in '{chapter_title}'...")
            modified_content = replace_links(chapter_content)
            print(f"Appending '{chapter_title}' to target file.")
            append_to_file(target_file, modified_content)
        else:
            print(f"Chapter '{chapter_title}' not found in source file.")
    
    print("Process complete.")

if __name__ == "__main__":
    main()
