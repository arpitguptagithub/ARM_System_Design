class ST_Entry:
    def __init__(self, entry_type=0, value=0):  # entry type = 0 for labels, 1 for variables
        self.value = value
        self.type = entry_type

    def __repr__(self):
        return f"ST_Entry(type={self.type}, value={self.value})"