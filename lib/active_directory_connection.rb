class ActiveDirectoryConnection

  attr_reader :ldap, :treebase

  def initialize

    @treebase = ENV['TREEBASE']
    @ldap = Net::LDAP.new host: ENV['AD_HOST'],
      port: 636,
      encryption: {
        method: :simple_tls
      },
      auth: {
        method: :simple,
        username: ENV['AD_USERNAME'],
        password: ENV['AD_PASSWORD']
      }

  end

  def add_user(ad_user)

    dn = fully_qualified_dn.call(ad_user.dn_name)

    if find_user(ad_user.dn_name)

      ldap.replace_attribute( dn, :unicodePwd, ad_user.attributes[:unicodePwd] )
      "User Found. " + get_result + "!"

    else

      ldap.add(dn: dn, attributes: ad_user.attributes)
      enable_account(dn)

      groups = ENV['AD_GROUPS'].split(',').map!(&fully_qualified_dn)
      groups.each do |group|
        set(group, dn)
      end
      set_primary_group(dn)

      "Adding new user: " + get_result + "!"
    end
  end

  private

  def find_user(name)
    filter = Net::LDAP::Filter.eq("cn", "#{name}")
    ldap.search(base: treebase, filter: filter)[0]
  end

  def enable_account(dn)
    ops = [[:replace, :useraccountcontrol, "544"]]
    execute(dn, ops)
  end

  def set(group, dn)
    ops = [[:add, :member, dn ]]
    execute(group, ops)
  end

  def set_primary_group(dn)
    ops = [[:replace, :primarygroupid, "1154"]]
    execute(dn, ops)
  end

  def execute(target, ops)
    ldap.modify dn: target, operations: ops
  end

  def get_result
    ldap.get_operation_result.message
  end

  def fully_qualified_dn
    Proc.new { |entry| "CN=#{entry},CN=Users,#{treebase}" }
  end
end
