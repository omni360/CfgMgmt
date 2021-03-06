dev_user = node['fsharp']['user']
home = node['fsharp']['home']

log "dev_user = #{dev_user}"
log "home = #{home}"

package 'git'

bash 'Add Xamarin Mono PPA' do
  code <<-EOH
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
  echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list
  apt-get update
  EOH
end

package 'mono-complete'
package 'fsharp'

bash 'Get nuget' do
  user dev_user
  cwd home
  code <<-EOH
  curl -L https://nuget.org/nuget.exe -o nuget.exe
  mozroots --import --sync
  EOH
end

git "#{home}/Project" do
  repository 'https://github.com/fsprojects/ProjectScaffold.git'
  revision 'master'
  user dev_user
end

log "Run build.sh in Project to scaffold project"
