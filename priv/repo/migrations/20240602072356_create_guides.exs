defmodule Guideme.Repo.Migrations.CreateGuides do
  use Ecto.Migration

  def change do
    create table(:guides) do
      add :chapter_id, references(:chapters, on_delete: :nothing)
      add :title, :text
      add :name, :string
      add :template_id, references(:templates, on_delete: :nothing)
      add :icon, :string
      add :introduction, :text

      timestamps(type: :utc_datetime)
    end

    create index(:guides, [:chapter_id])
    create index(:guides, [:template_id])
    create unique_index(:guides, [:name])

    create index(:guides, [:chapter_id],
             include: [:name, :template_id],
             name: :guide_directory_covering_index
           )
  end
end
