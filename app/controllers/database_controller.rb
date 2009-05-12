require 'rubygems'
require 'strscan'
require("chartdirector")
require 'spreadsheet/excel'
require 'rexml/document'
require 'rubygems'
require 'will_paginate'
require 'postgres'
$current_page=1

class DatabaseController < ApplicationController
     protect_from_forgery :only => [:update, :delete, :create]
      
    #$whose="192.168.1.157"
    $whose="localhost"
  def index
  end
  
 
  def create_tables
    conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
    res = conn.exec("select pg_database.datname from pg_database where "+
                      " pg_database.datname != 'template1'" +
                      " and pg_database.datname != 'template0' and pg_database.datname != 'template0';")
    @databases=[]
    @databases=res.to_a
    if params[:user]
     if params[:user][:tt]!=nil
      begin 
      picture=(params[:upload][:datafile])
      name = "sqlfile.sql"
      @filename=name.gsub(/[^\w._-]/, '')
      @content_type = picture.content_type.chomp
       Dir.mkdir("#{RAILS_ROOT}/public/data/}") unless File.exist?("#{RAILS_ROOT}/public/data/")
       File.open("#{RAILS_ROOT}/public/data/#{@filename}", "wb") do |f|
          f.write(picture.read)
        end 
      rescue Exception=>e
       flash[:notice]=e     
      end
      flash[:notice]="Successfully Created"
      begin
      
      db= params[:user][:tt]
      conn = PGconn.connect($whose, 5432, '', '', "#{db}", "postgres", "postgres")
      contents = ""  
      File.open("#{RAILS_ROOT}/public/data/sqlfile.sql") do |file|
      file.each_line { |line|
      contents = contents + line }
       end
      res = conn.exec(contents)
      rescue Exception=>e
       flash[:notice]=e
      end 
     end
    end
   end
    
   
   
  def list_db
    @databases=[]
    if params[:db]
     if params[:db][:user]!=nil and params[:db][:user]!=""
      begin
       conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
       res = conn.exec("CREATE DATABASE #{params[:db][:name]} WITH OWNER = #{params[:db][:user]} ENCODING = 'UTF8';")
       flash[:note]="Successfully Created"
      rescue Exception=>e
       flash[:note]=e
      end
     end
    end
  
    conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
    res = conn.exec("SELECT pg_database.datname as dd, "+
      " pg_user.usename  FROM pg_database, pg_user "+
      "WHERE pg_database.datdba = pg_user.usesysid and pg_database.datname != 'postgres' and pg_database.datname != 'template1' "+
      " and pg_database.datname != 'template0' and pg_database.datname != 'template0';")
    @databases=res.to_a
   end
  
  def new_edit_db
    conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
    res = conn.exec("select pg_user.usename  from  pg_user;")
    @users=[]
    @users=res.to_a
  end
  
  def delete_db
    begin
     conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
     res=conn.exec("drop database #{params[:db]};")
     flash[:note]="Successfully Deleted"
     redirect_to :action=>"list_db"
    rescue Exception=>e
      flash[:note]=e
      redirect_to :action=>"list_db"
    end
  end
  
  def backup_db
    begin
    puts params.inspect
    
    @file_name=""
    @output_path=""
#    @file_name=params[:file_name] if params[:file_name] and params[:file_name]!=""
#    @output_path=params[:output_path] if params[:output_path] and params[:output_path]!=""
    render :layout=>false
    rescue Exception=>e
    end
  end
  
  def backup_type
    @show_submit=false
    @data=false
    @schema=false
    puts params.inspect
    if params[:backup] and params[:backup]=="true"
      if params[:from] and params[:from]=="plain"
        @show_submit=false 
        if params[:from1] and params[:from1]!=""
         @show_submit=true
         @data=true if params[:from1]=="only_data"
         @schema=true if params[:from1]=="only_schema"
        end
        else
         @show_submit=true
      end
    end
    render :layout=>false
  end
  
  def update_backup
    begin
      extension="sql"
      conditions=""
      if params[:file_name] and params[:file_name].strip!="" and params[:output_path] and params[:output_path].strip!=""
      if params[:backup] and params[:backup]=="backup"
        extension="backup" 
        conditions="-F c -b -v -f"
      end
  
      if params[:backup] and params[:backup]=="tar"
        extension="tar" 
        conditions="-F t -b -v -f"
      end
  
      conditions="-F p -a -D -v -f" if params[:backup1] and params[:backup1]=="only_data"
      conditions="-F p -s -s -D -v -f" if params[:backup1] and params[:backup1]=="only_schema"
     
      fname=params[:file_name].strip
      path=params[:output_path].strip
      dname=params[:database_name].strip
      path[0, 1]="" if path[0, 1]=="/" #or path[0, 1]=="\"
      path[-1, 1]="" if path[-1, 1]=="/"
     
      path="/#{path}/#{fname}.#{extension}"
       puts path
      str="pg_dump -i -h #{$whose} -p 5432 -U postgres #{conditions} '"+path.to_s+"' #{dname}"
      system(str)
      flash[:note]="Database was dumped and stored in #{params[:output_path].strip}"
      else
        flash[:note]="Invalid filename/Path"
      end
      
      @download_url = "http://#{@request.env['SERVER_NAME']}/#{path}"

      send_file("#{@request.env['DOCUMENT_ROOT]'/#{path}",:type => "application/pdf")

      redirect_to :action=>"list_db"
    rescue Exception => e
      puts e
    end
  end
  
   def list_users
    if params[:user]
     if params[:user][:name]!=nil
      begin
       conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
       res = conn.exec("CREATE USER #{params[:user][:name]} WITH PASSWORD '#{params[:user][:password]}'")
       flash[:note]="Successfully Created"
      rescue Exception=>e
       flash[:note]=e
      end
     end
    end
    conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
    res = conn.exec("select pg_user.usename  from  pg_user;")
    @users=[]
    @users=res.to_a
   end
  
   def new_edit_user
    conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
    res = conn.exec("select distinct pg_user.usename from  pg_user;")
    @users=[]
    @users=res.to_a
   end
  
   def delete_user
    begin
     conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
     res=conn.exec("drop user '#{params[:user]}';")
     flash[:note]="Successfully Deleted"
     redirect_to :action=>"list_users"
    rescue Exception=>e
     flash[:note]=e
     redirect_to :action=>"list_users"
    end
   end

   
   def check_acess
    conn = PGconn.connect($whose, 5432, '', '', '', "malathi", "")
    res = conn.exec("select pg_user.usename  from  pg_user;")
    @users=[]
    @users=res.to_a
   end

   def main_frame
    conn = PGconn.connect($whose, 5432, '', '', '', "postgres", "postgres")
    res = conn.exec("SELECT pg_database.datname as dd, "+
      " pg_user.usename  FROM pg_database, pg_user "+
      "WHERE pg_database.datdba = pg_user.usesysid and pg_database.datname != 'postgres' and pg_database.datname != 'template1' "+
      " and pg_database.datname != 'template0' and pg_database.datname != 'template0';")
    @databases=[]
    @databases=res.to_a
   end

   def list_tables
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("SELECT distinct table_name FROM INFORMATION_SCHEMA.COLUMNS where table_schema='public';")
    @tables=[]
    @tables=res.to_a
   end
   
   def table_edit_row
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
    @table_structure=[]
    @table_structure=res.to_a
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("select  * from  #{params[:table]} where id=#{params[:edit_id]};")
    @table_contents=[]
    @table_contents=res.to_a 
   end

   def cancel_new_record
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
    @table_structure=[]
    @table_structure=res.to_a
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("select  * from  #{params[:table]} where id=#{params[:edit_id]};")
    @table_contents=[] 
    @table_contents=res.to_a
    render :layout=>false
   end

   def table_actions
   end

   def table_list_data
    @@per_page=10
    if params[:delete_content]=="yes"
     begin
      conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres") 
      res = conn.exec("delete from  #{params[:table]}  where id= #{params[:delete_id]} ;")
      flash[:note]="Deleted Successfully"
     rescue Exception=>e
      flash[:note]=e
      conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
      res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
      @table_structure=[]
      @table_structure=res.to_a
      conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
      res = conn.exec("select  * from  #{params[:table]} ;")
      @table_contents=[]
      @table_contents=res.to_a
      perpage = params[:per_page] || "25"
      pagenum= params[:page] || "1"
      @page_number=pagenum
      $c_page=@page_number
      
      if not params[:page].nil?
       a = (params[:page].to_i - 1) * perpage.to_i
       b = a + perpage.to_i
      else
       a = 0
       b = a + perpage.to_i
      end
      
      @table_contents= WillPaginate::Collection.new(pagenum, perpage, "#{@table_contents.length}").concat(@table_contents[a..b])
     end
    end
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
    @table_structure=[]
    @table_structure=res.to_a
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("select  * from  #{params[:table]} ;")
    @table_contents=[]
    @table_contents=res.to_a
    perpage = params[:per_page] || "30"
    pagenum= params[:page] || "1"
    $c_page=pagenum
    @page_number=pagenum
    if params[:delete_content]=="yes"
     @page_number=params[:page].to_i
     pagenum=@page_number
    end
  
    if not params[:page].nil?
     a = (params[:page].to_i - 1) * perpage.to_i
     b = a + perpage.to_i
    else
     a = 0
     b = a + perpage.to_i
    end
    @table_contents= WillPaginate::Collection.new(pagenum, perpage, "#{@table_contents.length}").concat(@table_contents[a..b])
    render :layout=>false
   end

   def table_list_structure
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
    @table_structure=[]
    @table_structure=res.to_a
    render :layout=>false
   end

   def delete_structure
    begin
     conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
     res=conn.exec("ALTER TABLE #{params[:table]} DROP COLUMN #{params[:structure]};")
     flash[:note]="Successfully removed"
     redirect_to :action=>"table_list_structure",:database=>params[:database],:table=>params[:table]
    rescue Exception=>e
     flash[:note]=e
     redirect_to :action=>"table_list_structure",:database=>params[:database],:table=>params[:table]
    end
   end

   def cancel_new_task
   end

   def edit_structure
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
    @table_structure=[]
    @table_structure=res.to_a
    $A=2 if $A==2
    if   params[:table_new]
     if params[:table_new][:column]!=""
      begin
       conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
       res=conn.exec("ALTER TABLE #{params[:table]} RENAME COLUMN #{params[:structure]} TO #{params[:table_new][:column]};")
       flash[:note]="Successfully changed"
       redirect_to :action=>"table_list_structure",:database=>params[:database],:table=>params[:table]
       $A=1
      rescue Exception=>e
       flash[:note]=e
       flash[:error]=e
       $A=2
       conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
       res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
       @table_structure=[]
       @table_structure=res.to_a
      end
     end
    end
   end

   def edit_structure_all
    @data_type=[]
    @data_type=["bigint","boolean", "text","integer","character","char","character varying","timestamp without time zone","timestamp with time zone","serial"]
    $B=2 if $B==2
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
    @table_structure=[]
    @table_structure=res.to_a
    if   params[:table_new]
     if params[:table_new][:column]!=""
      begin
        conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
        res=conn.exec("ALTER TABLE #{params[:table]} ALTER COLUMN #{params[:structure]} type #{params[:table_new][:structure_data]};")
        flash[:note]="Successfully changed"
        redirect_to :action=>"table_list_structure",:database=>params[:database],:table=>params[:table]
        $B=1
      rescue Exception=>e
       $B=2
       flash[:note]=e
       flash[:error]=e
      end
     end
    end
   end


   def add_structure
    $C=2 if $C==2
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
    @table_structure=[]
    @table_structure=res.to_a
    @data_type=[]
    @data_type=["bigint","boolean", "text","integer","character","char","character varying","timestamp without time zone","timestamp with time zone","serial"]
    if   params[:table_new]
     if params[:table_new][:column]!=""
      begin
       conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
       res=conn.exec("ALTER TABLE #{params[:table]} ADD COLUMN #{params[:table_new][:column]}  #{params[:table_new][:structure_data]};")
       if (params[:table_new][:active]).to_i==1
        additons="SET NOT NULL"
        res=conn.exec("ALTER TABLE #{params[:table]} ALTER COLUMN #{params[:table_new][:column]} SET NOT NULL;")
       end
       if params[:table_new][:default] !=""
        additions= "SET DEFAULT #{params[:table_new][:default]}"
        res=conn.exec("ALTER TABLE #{params[:table]} ALTER COLUMN #{params[:table_new][:column]}  #{additions};")
       end
        flash[:note]="Successfully changed"
        redirect_to :action=>"table_list_structure",:database=>params[:database],:table=>params[:table]
        $C=1
      rescue Exception=>e
       $C=1
       flash[:note]=e
       flash[:error]=e
       conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
       res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}';")
       @table_structure=[]
       @table_structure=res.to_a
      end
     end
    end
   end

   def save_table_row 
    conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
    res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}' order by ordinal_position;")
    @table_structure=[]
    @table_structure=res.to_a
    query=" update #{params[:table]} set "
    z=0
    g="NULL"
    @table_structure.each do |tab|
    z=z+1
    if z!=@table_structure.length
     if params[:"#{params[:table]}"][:"#{tab[0]}"]!=""
      query=query + tab[0] +"= '" + params[:"#{params[:table]}"][:"#{tab[0]}"] + "'"+" ,"
     else
      query=query + tab[0] +"= " + g +" ,"
     end
     else
      if params[:"#{params[:table]}"][:"#{tab[0]}"]!=""
        query=query + tab[0] +"= '" + params[:"#{params[:table]}"][:"#{tab[0]}"] + "'"+" where id=#{params[:edit_id]};" 
      else
        query=query + tab[0] +"= " + g +" where id='#{params[:edit_id]}';"
      end 
     end 
    end 
    begin
     res = conn.exec(query)
     redirect_to :action=>"cancel_new_record",:database=>params[:database],:table=>params[:table],:edit_id=>params[:edit_id],:update=>params[:update]
     flash[:note]="updated"
    rescue Exception=>e
     flash[:note]=e
     redirect_to :action=>"cancel_new_record",:database=>params[:database],:table=>params[:table],:edit_id=>params[:edit_id],:update=>params[:update]
    end
   end
   
   def add_table_data
     conn = PGconn.connect($whose, 5432, '', '', "#{params[:database]}", "postgres", "postgres")
     res = conn.exec("SELECT column_name,data_type FROM INFORMATION_SCHEMA.COLUMNS where table_name='#{params[:table]}' order by ordinal_position;")
     @table_structure=[]
     @table_structure=res.to_a
     if params[:table_new] 
        params[:table_new].each{|key,value| 
       
        }
     end
     query=""
     g="NULL"
     if params[:table_new]
      query=" INSERT INTO #{params[:table]} ( "
      k=0
      @table_structure.each do |tab|
      k=k+1
      if (tab[0]).to_s!="id" and k!= @table_structure.length
        query=query+"  "+tab[0]+ " , "
      else
       if (tab[0]).to_s!="id"
        query=query+"  "+tab[0]
       end
      end
     end
     query=query+" )  VALUES ( "
    end
    if params[:table_new]  
      k=0
      @table_structure.each do |tab|
      k=k+1
      if (tab[0]).to_s!="id" and k!= @table_structure.length
        if params[:table_new][:"#{tab[0]}"]!=""
         query=query+"  "+ "'"+params[:table_new][:"#{tab[0]}"]+"'"+ ' , '
        else
         query=query+"  " + g + ' , '
        end
      else
      if (tab[0]).to_s!="id"
        if params[:table_new][:"#{tab[0]}"]!=""
         query=query+"  "+"'"+params[:table_new][:"#{tab[0]}"]+"'"
        else
         query=query+"  "+ g
        end
       end
      end
     end
     query=query+" );"
     begin
     puts" comes into begin"
      res = conn.exec(query)
      flash[:note]="sucessfully executed"
      flash[:test]="sucessfully executed"
      
     rescue Exception=>e
    
      flash[:test]=" not sucessfully executed"
      flash[:note]=e
      flash[:error]=e
     end
    end
   end

end
