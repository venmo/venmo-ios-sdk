platform :ios, '9.0'
use_frameworks!

target 'venmo-sdk' do
  pod 'CMDQueryStringSerialization', '~> 0.2'
  pod 'VENCore', '~> 3.1'

  abstract_target 'specs' do
    pod 'Specta'
    pod 'Expecta'
    pod 'OCMock', '~> 2.2.4'
    pod 'Nocilla'

    target 'venmo-sdk-specs'
    target 'venmo-sdk-integration-specs'
  end
end
