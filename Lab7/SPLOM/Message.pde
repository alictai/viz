class Message {
    String src = null;
    Condition[] conds = null;
    String action = "normal";

    Message() {

    }

    Message setSource(String str) {
        this.src = str;
        return this;
    }

    Message setAction(String str) {
        this.action = str;
        return this;
    }

    Message setConditions(Condition[] conds) {
        this.conds = conds;
        return this;
    }

    boolean equals(Message msg) {
        if (msg == null) {
            return false;
        }
        if (src == null && msg.src == null) {
            return true;
        }
        if (src == null || msg.src == null) {
            return false;
        }
        if (!src.equals(msg.src)) {
            return false;
        }
        if (conds != null && msg.conds != null) {
            if (conds.length != msg.conds.length) {
                return false;
            }
            for (int i = 0; i < conds.length; i++) {
                if (!conds[i].equals(msg.conds[i])) {
                    return false;
                }
            }
            return true;
        } else {
            if (conds == null && msg.conds == null) {
                return true;
            } else {
                return false;
            }
        }
    }

    public String toString() {
        String str = "";
        for (Condition cond: conds) {
            str += cond.toString();
        }
        return str + "\n\n";
    }
}
