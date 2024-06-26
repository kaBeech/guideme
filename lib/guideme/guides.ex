defmodule Guideme.Guides do
  @moduledoc """
  The Guides context.
  """

  import Ecto.Query, warn: false
  alias Guideme.Repo

  alias Guideme.Guides.Guide

  @doc """
  Returns the list of guides.

  ## Examples

      iex> list_guides()
      [%Guide{}, ...]

  """
  def list_guides do
    Repo.all(Guide)
  end

  @doc """
  Gets a single guide.

  Raises `Ecto.NoResultsError` if the Guide does not exist.

  ## Examples

      iex> get_guide!(123)
      %Guide{}

      iex> get_guide!(456)
      ** (Ecto.NoResultsError)

  """
  def get_guide!(id), do: Repo.get!(Guide, id)

  @doc """
  Creates a guide.

  ## Examples

      iex> create_guide(%{field: value})
      {:ok, %Guide{}}

      iex> create_guide(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_guide(chapter, attrs \\ %{}) do
    chapter
    |> Ecto.build_assoc(:guides)
    |> Guide.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a guide.

  ## Examples

      iex> update_guide(guide, %{field: new_value})
      {:ok, %Guide{}}

      iex> update_guide(guide, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_guide(%Guide{} = guide, attrs) do
    guide
    |> Guide.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a guide.

  ## Examples

      iex> delete_guide(guide)
      {:ok, %Guide{}}

      iex> delete_guide(guide)
      {:error, %Ecto.Changeset{}}

  """
  def delete_guide(%Guide{} = guide) do
    Repo.delete(guide)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking guide changes.

  ## Examples

      iex> change_guide(guide)
      %Ecto.Changeset{data: %Guide{}}

  """
  def change_guide(%Guide{} = guide, attrs \\ %{}) do
    Guide.changeset(guide, attrs)
  end

  alias Guideme.Guides.Template

  @doc """
  Returns the list of templates.

  ## Examples

      iex> list_templates()
      [%Template{}, ...]

  """
  def list_templates do
    Repo.all(Template)
  end

  @doc """
  Gets a single template.

  Raises `Ecto.NoResultsError` if the Template does not exist.

  ## Examples

      iex> get_template!(123)
      %Template{}

      iex> get_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_template!(id), do: Repo.get!(Template, id)

  @doc """
  Creates a template.

  ## Examples

      iex> create_template(%{field: value})
      {:ok, %Template{}}

      iex> create_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(attrs \\ %{}) do
    %Template{}
    |> Template.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a template.

  ## Examples

      iex> update_template(template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_template(template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_template(%Template{} = template, attrs) do
    template
    |> Template.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a template.

  ## Examples

      iex> delete_template(template)
      {:ok, %Template{}}

      iex> delete_template(template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_template(%Template{} = template) do
    Repo.delete(template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking template changes.

  ## Examples

      iex> change_template(template)
      %Ecto.Changeset{data: %Template{}}

  """
  def change_template(%Template{} = template, attrs \\ %{}) do
    Template.changeset(template, attrs)
  end
end
