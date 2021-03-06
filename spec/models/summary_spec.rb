require File.dirname(__FILE__)+'/../spec_helper'

describe Summary do

  describe "basic_search" do
    it "should return results in alphabetical order" do
      @result_from_db = [summary_with_name("zubair"), summary_with_name("alice")]
      Summary.stub(:view).with(any_args()).any_number_of_times().and_return(@result_from_db)
      results = Summary.basic_search("alice", "")
      results.first()["name"].should =="alice"
      results.last()["name"].should == "zubair"
    end

    it "should return an empty array if there are no matching results" do
      results = Summary.basic_search( 'totally invalid name','absolutely not a valid id' )
      results.should == []
    end

  end
  
  def summary_with_name(name)
    sum = Summary.new
    sum["name"] = name
    sum
  end

  describe "and arrays" do
    it "should and arrays ignoring empty ones" do
      empty = []
      first = [1,2,3]
      second = [2,3]
      Summary.and_arrays(empty, first, second).should == [2,3]
    end
  end
  
  describe "advanced search" do
    
    it "should delegate search to child model" do
      Child.should_receive(:view_by).with(:name)
      Child.should_receive(:by_name).with({:startkey=>"francisco", :endkey=>"g"})
      
      search = AdvancedSearch.new("name","francisco")
      Summary.advanced_search(search)    
    end
    
    
  end
end
