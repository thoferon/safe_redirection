require 'spec_helper'

describe SafeRedirection::Sanitizer do
  let(:resolver) { double('resolver') }
  let(:base_url) { "http://test.tld/" }
  let(:default_url) { "http://test.tld/default" }

  subject { SafeRedirection::Sanitizer.new(resolver, base_url, default_url) }

  describe '#safe_url_for' do
    context "with a valid URL" do
      let(:valid_url) { "http://test.tld/valid" }
      let(:params) { { :controller => 'home', :action => 'valid' } }

      it "should return this very URL" do
        resolver.should_receive(:recognize_path).with('/valid', anything).and_return(params)
        subject.safe_url_for(valid_url).should == params
      end
    end

    context "with an invalid URL" do
      it "should return the default URL" do
        resolver.should_receive(:recognize_path).with('/rubbish', anything).and_raise('ActionController::RoutingError')
        subject.safe_url_for("http://test.tld/rubbish").should == default_url
      end

      it "should return the default URL with a non-HTTP(S) scheme" do
        subject.safe_url_for("ftp://test.tld/").should == default_url
      end
    end

    context "when the application is not at the root" do
      let(:base_url) { "http://test.tld/some/path/" }

      it "should try to resolve the subpath" do
        resolver.should_receive(:recognize_path).with('/subpath', anything)
        subject.safe_url_for('http://test.tld/some/path/subpath')
      end
    end

    context "when the resolver raises SafeRedirection::SanitizationCancelled" do
      it "returns the URL passed" do
        resolver.stub(:recognize_path).and_raise(SafeRedirection::SanitizationCancelled)
        url = '/some/path?param=value'
        subject.safe_url_for(url).should == url
      end
    end
  end

  describe "#base_path" do
    context "with a trailing slash" do
      let(:base_url) { "http://test.tld/some/path/" }
      its(:base_path) { should == "/some/path" }
    end

    context "without a trailing slash" do
      let(:base_url) { "http://test.tld/some/path" }
      its(:base_path) { should == "/some/path" }
    end
  end

  describe "#relative_path" do
    let(:base_url) { "http://test.tld/in/so.me/path/" }

    it "should strip the base path" do
      subject.relative_path('/in/so.me/path/subpath').should == '/subpath'
    end

    it "should not strip it if it's not in the beginning" do
      path = '/not/in/so.me/path/subpath'
      subject.relative_path(path).should == path
    end

    it "should not interpret regular expressions in the base URL's path" do
      path = '/in/soZme/path/subpath'
      subject.relative_path(path).should == path
    end
  end
end
