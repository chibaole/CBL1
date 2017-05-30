AdminConfig.configure do |conf|
  conf.add('code_batch') do |model|
    model.add_action name: 'generate_codes', method: :patch, type: :member, text: '核销码生成'
  end
end
