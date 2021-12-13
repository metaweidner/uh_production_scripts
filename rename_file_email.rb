# source: https://github.com/halleyrv/rename-files/blob/master/rename_file_email.rb

# --------------------------------
# INSTRUCCIONES:
# ----------------------
# 1) Si deseas agregar un nuevo caracter que sea reemplazado mira Instrucción I
# 2) Para colocar el directorio que deseas buscar mira en Instrucción II
# 3) Para ejecutar el archivo te ubicas en el directorio donde coloque este archivo ruby
#    y ejecutas ruby rename_file_email.rb
# Listo!
class RenameFile
  attr_accessor :number_files_rename
  def initialize()
    @number_files_rename = 0
    # --------------------------
    # INSTRUCCIÓN I
    # -----------------------
    # Si quieres agregara algún caracter mas extraño que 
    # desees que se reemplace con espacio vacio,
    # lo agregas dentro de este array como 
    # un objeto mas dentro con comillas.
    # Ejemplo si quisieras que reemplace los % entonces harias lo 
    # siguiente:
    #  @characters_to_replace = ['?', '%']
    # Actualmente esta para reemplazar ?
    # tambien dentro de el metodo replace_characters_with_blank
    # estoy eliminando los espacios en blanco con la sentencia
    # delete(' ')
    # Si no deseas que se elminen esos espacios en blanco entonces comenta esa linea
    @characters_to_replace = ['?']
  end


  def replace_characters_with_blank(string)
    @characters_to_replace.each do |character_to_replace|
      string = string.gsub(character_to_replace, '')
      string = string.delete(' ')
    end
    string  
  end  

  def iterate_directory_recursive(path)
    if File.directory?(path)
      Dir.each_child(path) { |directory|
        current_path_recursive = path+"/"+directory
        iterate_directory_recursive(current_path_recursive)
        rename_file(path, directory) if File.file?(current_path_recursive)
      }  
    end
  end
  
  def rename_file(folder_path, file_name)
    path_file = folder_path + "/"+file_name
    new_file_name = replace_characters_with_blank(file_name)
    File.rename(path_file, folder_path + "/" + new_file_name)
    @number_files_rename+=1
    puts "#{@number_files_rename} archivos renombrados"
  end  

end

rename_file = RenameFile.new()
# INSTRUCCIÓN II :
puts " Proceso iniciado.............."
rename_file.iterate_directory_recursive("/Users/halley/Downloads/chingadera")
puts " Proceso de terminado!!. Sus archivos han sido renombrados "