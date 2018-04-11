class ActiveDirectoryUser

  attr_reader :first_name, :last_name, :attributes

  def initialize(request)
    @first_name = request[:first_name]
    @last_name = request[:last_name]
    @attributes = build
  end

  def dn_name
    first_name + ' ' + initials + ' ' + last_name
  end

  private

  def build
    {
      givenname: [first_name],
      initials: [initials],
      sn: [last_name],
      objectclass: ["top", "person", "organizationalPerson", "user"],
      samaccountname: [username],
      userprincipalname: [ username + ENV["AD_PRINCIPAL_NAME"] ],
      profilepath: [ ENV["AD_PROFILE_PATH"] + username ],
      physicaldeliveryofficename: ["New York"],
      title: ["Artist"],
      department: ["Post"],
      company: ["Freelance"]
    }
  end

  def username
    first_name[0].downcase + last_name.downcase.delete(' ')
  end

  def initials
    first_name[0] + last_name[0] + '.'
  end
end
