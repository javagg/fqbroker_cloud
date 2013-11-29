class UpdateAppConfigOp < PendingAppOp

  field :add_keys_attrs, type: Array, default: []
  field :remove_keys_attrs, type: Array, default: []
  field :add_env_vars, type: Array, default: []
  field :remove_env_vars, type: Array, default: []
  field :config, type: Hash, default: {}
  field :recalculate_sshkeys, type: Boolean, default: false
  field :gear_id, type: String

  def isParallelExecutable()
    return true
  end

  def addParallelExecuteJob(handle)
    gear = get_gear()
    unless gear.removed
      # if recalculate_sshkeys is set to true, re-calculate the ssh keys to add
      app = Application.find_by(_id: self.application._id)
      self.add_keys_attrs = app.get_all_updated_ssh_keys
      
      tag = { "op_id" => self._id.to_s }
      gear.update_configuration(self, handle, tag)
    end
  end

end
