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

def append_to_file(target_path, content):
    """
    Appends the extracted content to another Markdown file.
    """
    with open(target_path, 'a', encoding='utf-8') as file:
        file.write(content)
        #file.write("\n\n")  # Add spacing before the new content

def main():
    source_file = "README.md"  # Path to the source Markdown file
    target_file = "./instructions-short.md"  # Path to the target Markdown file
    chapters_to_extract = [
        "# iCAT: A Multifunctional Open-Source Accessory for Advanced Light Microscopy", 
        "## Supplies"
        ]  # List of chapters to extract
    
    for chapter_title in chapters_to_extract:
        print(f"Extracting '{chapter_title}'...")
        chapter_content = extract_chapter(source_file, chapter_title)
        if chapter_content:
            print(f"Appending '{chapter_title}' to target file.")
            append_to_file(target_file, chapter_content)
        else:
            print(f"Chapter '{chapter_title}' not found in source file.")
    
    print("Process complete.")

if __name__ == "__main__":
    main()