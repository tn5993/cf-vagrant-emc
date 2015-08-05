#Get rid of libcurl error when do bundle install
package "libcurl4-openssl-dev" do
  action :install
end

#Get rid of libcurl error when do bundle install
package "libcurl3" do
  action :install
end

package "zip" do
  action :install
end

package "unzip" do
  action :install
end
