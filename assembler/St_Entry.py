class ST_Entry:
    def __init__(self, entry_type=0, value=0):  
        """
        LABLES : entry_type=1 
        can extend to other sections by changing the entry_type
        """
        self.value = value
        self.type = entry_type
        self.is_global = False
    
    def set_global(self):
        self.is_global = True

    def __repr__(self):
        return f"ST_Entry(type={self.type}, value={self.value}, is_global={self.is_global})"
    