module Rename
  extend self

  def get_parts path
    path_parts = {}
    path_parts['directory'] = path.dirname.to_s
    path_parts['basename'] = path.basename.sub_ext('').to_s
    path_parts['ext'] = path.extname.to_s
    path_parts
  end

  def full_object path, names
    path_parts = get_parts path
    carp = names['carp_name']
    do_ark = names['do_ark']
    ext = path_parts['ext']
    if path.basename.to_s.include? 'metadata'
      new_name = carp + '_' + do_ark + "_digi_metadata" + ext
    else
      new_name = carp + '_' + do_ark + ext
    end
    new_path = "#{path_parts['directory']}\\#{new_name}"
    old_path = Pathname.new("#{names['project']}\\#{path}")
    old_path.rename("#{names['project']}\\#{new_path}")
  end

  def xml path, names
    path_parts = get_parts path
    carp = names['carp_name']
    do_ark = names['do_ark']
    ext = path_parts['ext']
    num = "%04d" % path_parts['basename'].split('_')[-3].to_i
    type = path_parts['basename'].split('_')[-2]
    new_name = carp + '_' + do_ark + '_' + num + '_' + type + '_alto' + ext
    new_path = "#{path_parts['directory']}\\#{new_name}"
    old_path = Pathname.new("#{names['project']}\\#{path}")
    old_path.rename("#{names['project']}\\#{new_path}")
  end

  def tif path, names
    path_parts = get_parts path
    carp = names['carp_name']
    do_ark = names['do_ark']
    ext = path_parts['ext']
    if path_parts['basename'].split('_')[-2].length > 2
      num = "%04d" % path_parts['basename'].split('_')[-2].to_i
    else
      num1 = "%04d" % path_parts['basename'].split('_')[-3].to_i
      num2 = "%02d" % path_parts['basename'].split('_')[-2].to_i
      num = num1 + '_' + num2
    end
    type = path_parts['basename'].split('_')[-1]
    new_name = carp + '_' + do_ark + '_' + num + '_' + type + ext
    new_path = "#{path_parts['directory']}\\#{new_name}"
    old_path = Pathname.new("#{names['project']}\\#{path}")
    old_path.rename("#{names['project']}\\#{new_path}")
  end

  def targets paths, names
    paths.each_with_index do |path, i|
      num = "%04d" % i
      path_parts = get_parts path
      ext = path_parts['ext']
      new_name = num + "_target_pm" + ext
      new_path = "#{path_parts['directory']}\\#{new_name}"
      old_path = Pathname.new("#{names['project']}\\#{path}")
      old_path.rename("#{names['project']}\\#{new_path}")
    end
  end

end