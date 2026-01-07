
import sys
from PIL import Image, ImageDraw, ImageFont

# Check if Pillow is installed
try:
    from PIL import Image
except ImportError:
    print("Pillow is not installed. Please install it using: pip install Pillow")
    sys.exit(1)

def create_feature_graphic(screenshots, output_path):
    """
    Creates a Play Store feature graphic.
    """
    # Feature graphic dimensions
    width = 1024
    height = 500

    # Create a new white image
    feature_graphic = Image.new("RGB", (width, height), "white")

    # Load screenshots and resize them
    images = [Image.open(path) for path in screenshots]
    
    # Simple collage: place images side-by-side
    # Resize images to fit into the graphic
    resized_images = []
    total_width = 0
    for img in images:
        # maintain aspect ratio
        aspect_ratio = img.height / img.width
        new_width = (height - 40) / aspect_ratio # 20px padding top and bottom
        new_height = height - 40
        resized_img = img.resize((int(new_width), int(new_height)), Image.Resampling.LANCZOS)
        resized_images.append(resized_img)
        total_width += resized_img.width

    # Calculate starting x-position to center the collage
    x_offset = (width - total_width) // 2
    
    # Paste images onto the feature graphic
    for img in resized_images:
        feature_graphic.paste(img, (x_offset, 20))
        x_offset += img.width

    # Add a title
    draw = ImageDraw.Draw(feature_graphic)
    try:
        # Use a built-in font if available, otherwise a default one
        font = ImageFont.truetype("flutter/pomodoro_timer/assets/fonts/Quicksand-Bold.ttf", 40)
    except IOError:
        font = ImageFont.load_default()

    title_text = "Pomodoro Timer: Focus & Productivity"
    text_width, text_height = draw.textbbox((0,0), title_text, font=font)[2:]
    text_x = (width - text_width) / 2
    text_y = 10 # A bit of padding from the top

    # Add a simple background for the text
    draw.rectangle([text_x - 10, text_y - 5, text_x + text_width + 10, text_y + text_height + 5], fill="black")
    draw.text((text_x, text_y), title_text, font=font, fill="white")


    # Save the image
    feature_graphic.save(output_path)
    print(f"Feature graphic saved to {output_path}")

if __name__ == "__main__":
    # List of screenshot files
    screenshots = [
        "/Users/avtanshgupta/Desktop/PomodoroTimer/flutter/pomodoro_timer/screenshots/android-mobile/Screenshot_20260107_225215.png",
        "/Users/avtanshgupta/Desktop/PomodoroTimer/flutter/pomodoro_timer/screenshots/android-mobile/Screenshot_20260107_225355.png",
        "/Users/avtanshgupta/Desktop/PomodoroTimer/flutter/pomodoro_timer/screenshots/android-mobile/Screenshot_20260107_225112.png",
        "/Users/avtanshgupta/Desktop/PomodoroTimer/flutter/pomodoro_timer/screenshots/android-mobile/Screenshot_20260107_224937.png"
    ]
    output_file = "feature_graphic.png"
    create_feature_graphic(screenshots, output_file)
