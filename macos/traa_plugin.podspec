#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint traa_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'traa_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'

  podspec_path = File.expand_path(__FILE__)
  podspec_dir = File.dirname(podspec_path)
  real_podspec_dir = File.realpath(podspec_dir)

  # extra native module traa
  traa_source_dir = "#{real_podspec_dir}/../thirdparty/traa"
  traa_build_dir = "#{traa_source_dir}/build"
  s.prepare_command = <<-CMD
    cmake -G Xcode \
      -B #{traa_build_dir} \
      -DCMAKE_TOOLCHAIN_FILE=#{traa_source_dir}/cmake/ios.toolchain.cmake \
      -DPLATFORM=MAC_UNIVERSAL \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_BUILD_TYPE=Release \
      -S #{traa_source_dir}
    cmake --build #{traa_build_dir} --config Release
    mkdir -p #{real_podspec_dir}/Frameworks
    cp -RP #{traa_build_dir}/output/Release/traa.framework #{real_podspec_dir}/Frameworks/traa.framework
  CMD
  s.vendored_frameworks = 'Frameworks/*.framework', 'Frameworks/*.xcframework'

  # if plugin need to link with traa, uncomment the following lines
  # s.pod_target_xcconfig = {
  #   "OTHER_LDFLAGS" => ["$(inherited)", "-framework traa"],
  #   "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES", 
  #   "FRAMEWORK_SEARCH_PATHS" => ["$(inherited)","Frameworks"],
  #   "HEADER_SEARCH_PATHS" => ["$(inherited)", "Frameworks/traa.framework/Headers"], 
  # }
  # s.frameworks = 'traa'
end
