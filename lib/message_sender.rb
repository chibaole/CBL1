class MessageSender
  def initialize(phone, project_id = '', vars = {}, config = {})
    default = {
      "appid" => '',
      "appkey" => '',
      "signtype" => 'md5'
    }

    @project_id = ''

    @config = config.reverse_merge(default)
    @phone = phone
    @project_id = project_id unless project_id
    @vars = vars
  end

  def vars=(vars = {})
    @vars = vars
  end

  def xsend(vars = {})
    @vars = vars unless vars.empty?

    messagexsend = Submail::MessageXSend.new(@config)
    messagexsend.add_to(@phone)
    messagexsend.set_project(@project_id)
    @vars.each do |key, val|
      messagexsend.add_var(key.to_s, val)
    end

    messagexsend.message_xsend()
  end
end
