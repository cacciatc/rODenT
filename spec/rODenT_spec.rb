require 'rODenT'

describe "rODent's" do
  describe Rat do
    it "should list paragraphs" do
      rat = Rat.scurry('test\test.odt') 
      rat.paragraphs.empty?.should == false
    end
    it "should list lists" do
      rat = Rat.scurry('test\test.odt') 
      rat.lists.empty?.should == false
    end
    it "should list footnotes" do
      rat = Rat.scurry('test\test.odt') 
      rat.footnotes.empty?.should == false
    end
    it "should list tables" do
      rat = Rat.scurry('test\test.odt') 
      rat.tables.empty?.should == false
    end
  end
end