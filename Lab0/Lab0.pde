int screenWidth = 400;
int screenHeight = 300;

Button button;

void setup () {
    size (screenWidth, screenHeight);
    button = new Button(screenHeight, screenWidth, screenWidth/4, screenHeight/4);
    
}

void draw () {
    background(255, 255, 255);
    if (button.getIsect() == true) {
        button.update();
    }
    button.draw_button();
}

void mouseClicked() {
    button.intersect(mouseX, mouseY);
}
