int canvasWidth = MIN_INT; // this would be initialized in setup
float[] xs;
float[] ys;

void draw() {
  clearCanvas();

  /**
   ** Finish this:
   **
   ** you should draw your scatterplot here, on rect(0, 0, canvasWidth,canvasWidth) (CORNER)
   ** axes and labels on axes are required
   ** the hovering is optional
   **/
   
   Scatterplot scatter = new Scatterplot(canvasWidth, xs, ys);
   scatter.draw_graph();
   
}
