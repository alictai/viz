import java.util.Iterator;
import java.lang.Iterable;

abstract class Controller {
    protected ArrayList < AbstractView > vizs = null;
    protected Rectangle selectArea = null;
    protected Message preMsg = null;

    public abstract void receiveMsg(Message msg);
    public abstract void initViews();
    public abstract void setPosition();
    public abstract void handleSelectedArea();

    public void hover() {
        for (AbstractView v: vizs) {
            if (v.isOnMe()) {
                v.hover();
                break;
            }
        }
    }

    public void drawSelectedArea() {
        pushStyle();
        if (selectArea != null) {
            fill(selectColor);
            stroke(selectColor);
            rectMode(CORNER);
            rect(selectArea.p1.x, selectArea.p1.y,
                selectArea.p2.x - selectArea.p1.x, selectArea.p2.y - selectArea.p1.y);

        }
        popStyle();
    }

    public void drawViews() {
        for (AbstractView v: vizs) {
            v.display();
        }
    }

    public void cleanSelectedArea() {
        if (selectArea != null) {
            Message msg = new Message();
            msg.setSource("controller")
                .setAction("clean");
            receiveMsg(msg);
            selectArea = null;
        }
    }

    public void setSelectedArea(float x, float y, float x1, float y1) {
        selectArea = new Rectangle(x, y, x1, y1);
    }

    public void resetMarks() {
        // marks are global
        marks = new boolean[data.getRowCount()];
    }

    public void setMarksOfViews(){
        for (AbstractView abv: vizs) {
            abv.setMarks(marks);
        }
    }
}

class SPLOMController extends Controller {
    SPLOMController() {
        vizs = new ArrayList < AbstractView > ();
        selectArea = null;
    }

    public void initViews() {
        int row = data.getRowCount();
        int col = data.getColumnCount();

        float curX = margin, curY = margin;
        float xSeg = (width - margin * 2) / col;
        float ySeg = (height - margin * 2) / col;

        for (int i = 0; i < col; i++) {
            for (int j = 0; j < col; j++) {
                float[] xArray = data.getFloatColumn(i);
                float[] yArray = data.getFloatColumn(j);

                ScatterplotView spView = new ScatterplotView();
                spView
                    .setController(this)
                    .setName(i + "-" + j)
                    .setPosition(curX + i * xSeg, curY + j * ySeg)
                    .setSize(xSeg, ySeg)
                    .setMarks(marks)
                    ;

                spView.setData(xArray, yArray)
                    .setTitles(header[i], header[j])
                    .setXYIndice(i, j)
                    .initXYRange()
                    ;
              
                vizs.add(spView);
            }
        }
    }

    public void setPosition() {
        int row = data.getRowCount();
        int col = data.getColumnCount();

        float curX = margin, curY = margin;
        float xSeg = (width - margin * 2.0) / col;
        float ySeg = (height - margin * 2.0) / col;

        for (int i = 0; i < col; i++) {
            for (int j = 0; j < col; j++) {
                AbstractView spView = vizs.get(i * col + j);
                spView
                    .setPosition(curX + i * xSeg, curY + j * ySeg)
                    .setSize(xSeg, ySeg);
            }
        }
    }

    public void receiveMsg(Message msg) {
        if (msg.equals(preMsg)) {
            return;
        }

        preMsg = msg;

        if (msg.action.equals("clean")) {
            resetMarks();
            return;
        }

        Iterator it = data.rows().iterator();
        int index = 0;
        while (it.hasNext()) {
            if (checkConditions(msg.conds, (TableRow) it.next())) {
                marks[index] = true;
            } 
            index++;
        }
        setMarksOfViews();
    }


    public void handleSelectedArea() {
        Message msg = new Message();
        msg.action = "clean";
        receiveMsg(msg);

        if (selectArea != null) {
            for (AbstractView absv: vizs) {
                absv.handleThisArea(selectArea);
            }
        }
    }
}
