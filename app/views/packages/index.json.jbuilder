json.array!(@packages) do |package|
  json.set! 'package' do
    json.extract! package, :name, :current_version

    description = package.current_description
    if description.present?
      json.set! 'description' do
        json.extract! description, :title, :description

        json.set! 'authors' do
          json.array!(description.authors) do |author|
            json.extract! author, :name
          end
        end

        json.set! 'maintainers' do
          json.array!(description.maintainers) do |maintainer|
            json.extract! maintainer, :name, :email
          end
        end
      end
    end
  end
end
