class Mite::Account < Mite::SingletonBase
  include Mite::ResourceWithoutWriteAccess

  self.collection_name = 'account'

  def self.my_account
    account = (format.decode(connection.get(collection_path, headers).body) || {})
    account ? instantiate_record(account) : nil
  end

end
