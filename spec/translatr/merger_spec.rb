require 'spec_helper'

module Translatr
  describe Merger do
    let(:fixture_path) { File.join(File.expand_path(File.dirname(__FILE__)), '..', 'fixtures') }
    let(:target_path) { File.join(fixture_path, 'target.yml').to_s }
    let(:source_path) { File.join(fixture_path, 'source.yml').to_s }

    describe "initialization" do
      it "works without any attributes" do
        merger = Translatr::Merger.new
        merger.should be_a Translatr::Merger
      end

      it "takes source file as attribute" do
        merger = Translatr::Merger.new(source_path)
        merger.source_filename.should == source_path
        merger.source_locale.should == :en
      end

      it "takes target file as attribute" do
        merger = Translatr::Merger.new(nil, target_path)
        merger.target_filename.should == target_path
        merger.target_locale.should == :xx
      end

      it "takes source and target file as attributes" do
        merger = Translatr::Merger.new(source_path, target_path)

        merger.source_filename.should == source_path
        merger.source_locale.should == :en

        merger.target_filename.should == target_path
        merger.target_locale.should == :xx
      end
    end

    describe "initialized" do
      let(:merger) { Translatr::Merger.new }

      describe "#load_target" do
        before do
          merger.load_target target_path
        end

        it "sets the target filename" do
          merger.target_filename.should == target_path
        end

        it "sets the target locale" do
          merger.target_locale.should == :xx
        end

        it "loads the file into target" do
          merger.target.should == { :foo => "bar" }
        end
      end

      describe "#load_source" do
        before do
          merger.load_source source_path
        end

        it "sets the source filename" do
          merger.source_filename.should == source_path
        end

        it "sets the source locale" do
          merger.source_locale.should == :en
        end

        it "loads the file into source" do
          merger.source.should == { :foo => "baz" }
        end
      end

      describe "#merge" do
        it "merges source into target" do
          merger.load_target target_path
          merger.load_source source_path

          merger.merge.should == { :foo => "baz" }
        end

        it "overwrites entries in target that are different in source" do
          merger.target = { :foo => "target" }
          merger.source = { :foo => "source" }
          merger.merge.should == { :foo => "source" }
        end

        it "keeps entries in target that are not in source" do
          merger.target = { :foo => "target", :bar => "baz" }
          merger.source = { :foo => "source" }
          merger.merge.should == { :foo => "source", :bar => "baz" }
        end

        it "ignores entries that are in source but not in target" do
          merger.target = { :foo => "target" }
          merger.source = { :foo => "source", "bar" => "baz" }
          merger.merge.should == { :foo => "source" }
        end

        it "works with multidimensional entries" do
          merger.target = { :foo => "target", :bar => { :baz => "beng", :wuz => "up" } }
          merger.source = { :foo => "source", :bar => { :baz => "pong" } }
          merger.merge.should == { :foo => "source", :bar => { :baz => "pong", :wuz => "up" } }
        end

        it "ignores entries with variable mismatch" do
          merger.target = { :foo => "target", :bar => "target %{baz}" }
          merger.source = { :foo => "source %{bar}", :bar => "source %{baz}" }
          merger.merge.should == { :foo => "target", :bar => "source %{baz}" }
        end

        it "works with entries where variables match but their numbers differ" do
          merger.target = { :foo => "target %{bar}", :bar => "target %{baz} %{baz}" }
          merger.source = { :foo => "source %{bar} %{bar}", :bar => "source %{baz}"}
          merger.merge.should == { :foo => "source %{bar} %{bar}", :bar => "source %{baz}" }
        end

        it "ignores entries with markup when target has none and key doesn't end with '_html'"
      end

      describe "#variables_in" do
        it "gives nil for string without variables" do
          merger.variables_in("foo").should be_nil
        end

        it "gives the name of a single variables in a string" do
          merger.variables_in("foo %{bar}").should == ["%{bar}"]
        end

        it "gives a list of variables in a string" do
          merger.variables_in("foo %{bar}, %{baz}").should == ["%{bar}", "%{baz}"]
        end

        it "gives duplicate variables only once" do
          merger.variables_in("foo %{bar}, %{bar}").should == ["%{bar}"]
        end
      end

      describe "#store" do
        before do
          merger.load_target target_path
          merger.load_source source_path
        end

        it "saves the merged data to a file with the given filename" do
          filename = File.join(fixture_path, 'merged.yml').to_s
          merger.store(filename)
          data = YAML.load_file(filename)
          File.delete(filename)

          data.should == { "xx" => { "foo" => "baz" } }
        end

        it "saves the merged data to the target file when no filename is given" do
          File.should_receive(:open).with(target_path, "w")
          merger.store
        end
      end
    end
  end
end
