require 'spec_helper'

describe SafeRedirection::Resolvers::ExceptionsResolver do
  let(:resolver) { double('resolver') }

  subject { SafeRedirection::Resolvers::ExceptionsResolver.new(resolver) }

  describe "#recognize_path" do
    it "should delegate to the resolver" do
      resolver.should_receive(:recognize_path)
      subject.recognize_path("http://test.tld/some/path")
    end

    context "with a legitimate URL" do
      it "should return this URL" do
        legitimate_url = "http://else.where/far/far/away"
        subject.legitimate_urls << legitimate_url
        subject.recognize_path(legitimate_url).should == legitimate_url
      end
    end

    context "with a legitimate base URL" do
      it "should return the URL passed" do
        legitimate_base_url = "http://else.where/far/"
        legitimate_url = "#{legitimate_base_url}far/away"
        subject.legitimate_base_urls << legitimate_base_url
        subject.recognize_path(legitimate_url).should == legitimate_url
      end
    end
  end
end
