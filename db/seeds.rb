# coding: utf-8
Admin.create! email: 'test@gmail.com', password: 'test1234' if Admin.count == 0

unless Rails.env.production?
    connection = ActiveRecord::Base.connection
    connection.tables.each do |table|
        connection.execute("TRUNCATE #{table}") unless table == "schema_migrations"
    end

    sql = File.read('db/data.sql')
    statements = sql.split(/;$/)
    statements.pop

    ActiveRecord::Base.transaction do
        statements.each do |statement|
            connection.execute(statement)
        end
    end
end

