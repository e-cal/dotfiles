import argparse
import json
import os
from pathlib import Path
from mistralai import DocumentURLChunk, Mistral
from mistralai.models import OCRResponse

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--images", action="store_true", help="Include images in the output markdown")
parser.add_argument("file", type=str, help="Path to the PDF file to be processed")
args = parser.parse_args()

api_key = os.getenv("MISTRAL_API_KEY")
client = Mistral(api_key=api_key)

pdf_file = Path(args.file)
assert pdf_file.is_file()

# Upload PDF file to Mistral's OCR service
uploaded_file = client.files.upload(file={
    "file_name": pdf_file.stem,
    "content": pdf_file.read_bytes(),
}, purpose="ocr")

signed_url = client.files.get_signed_url(file_id=uploaded_file.id, expiry=1)
pdf_response = client.ocr.process(document=DocumentURLChunk(document_url=signed_url.url), model="mistral-ocr-latest", include_image_base64=True)

# response_dict = json.loads(pdf_response.model_dump_json())
# print(json.dumps(response_dict, indent=4)[0:1000])


def replace_images_in_markdown(markdown_str: str, images_dict: dict) -> str:
    """
    Replace image placeholders in markdown with base64-encoded images.

    Args:
        markdown_str: Markdown text containing image placeholders
        images_dict: Dictionary mapping image IDs to base64 strings

    Returns:
        Markdown text with images replaced by base64 data
    """
    for img_name, base64_str in images_dict.items():
        if args.images:
            markdown_str = markdown_str.replace(f"![{img_name}]({img_name})", f"![{img_name}]({base64_str})")
        else:
            markdown_str = markdown_str.replace(f"![{img_name}]({img_name})", f"![{img_name}](image)")
    return markdown_str


def get_combined_markdown(ocr_response: OCRResponse) -> str:
    """
    Combine OCR text and images into a single markdown document.

    Args:
        ocr_response: Response from OCR processing containing text and images

    Returns:
        Combined markdown string with embedded images
    """
    markdowns: list[str] = []
    # Extract images from page
    for page in ocr_response.pages:
        image_data = {}
        for img in page.images:
            image_data[img.id] = img.image_base64
        # Replace image placeholders with actual images
        markdowns.append(replace_images_in_markdown(page.markdown, image_data))

    return "\n\n".join(markdowns)


# Display combined markdowns and images
print(get_combined_markdown(pdf_response))
