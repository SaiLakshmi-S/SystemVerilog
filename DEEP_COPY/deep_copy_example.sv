class StudentMarks;
    string name;
    int marks[];
    
    
    function StudentMarks deep_copy();
        StudentMarks s = new();
        
  
        s.name = this.name;
   
        s.marks = new[this.marks.size()];
        foreach(this.marks[i])
            s.marks[i] = this.marks[i];
        
        return s;
    endfunction
endclass

module test;
    initial begin
        StudentMarks s1, s2;
        
        s1 = new();
        s1.name = "John";
        s1.marks = new[3];
        s1.marks = '{90, 85, 88};
        
        // DEEP COPY
        s2 = s1.deep_copy();
        
        s2.name = "Mike";
        s2.marks[0] = 100;
        
        $display("s1 name: %s", s1.name);     
        $display("s1 marks[0]: %0d", s1.marks[0]); 
        
        $display("s2 name: %s", s2.name);      
        $display("s2 marks[0]: %0d", s2.marks[0]);
    end
endmodule
