defmodule Coluguide.Steps do
  @moduledoc """
  The Steps context.
  """

  import Ecto.Query, warn: false
  alias Coluguide.Repo

  alias Coluguide.Steps.Step

  @doc """
  Returns the list of steps.

  ## Examples

      iex> list_steps()
      [%Step{}, ...]

  """
  def list_steps do
    Repo.all(Step)
  end

  @doc """
  Returns the list of a guide's steps

  Raises `Ecto.NoResultsError` if the Guide does not exist or has no steps.

  ## Examples

      iex> list_guide_steps!(123)
      [%Step{}, ...]

      iex> list_guide_steps!(456)
      ** (Ecto.NoResultsError)

  """
  def list_guide_steps!(id) do
    Repo.query!(
      "SELECT number, full_text, external_link, details_links.guide_id, src, alt " <>
        "FROM steps " <>
        "LEFT JOIN details_links " <>
        "ON steps.id = details_links.step_id " <>
        "LEFT JOIN step_images " <>
        "ON steps.id = step_images.step_id " <>
        "LEFT JOIN images " <>
        "ON step_images.image_id = images.id " <>
        "WHERE steps.guide_id = $1 " <>
        "ORDER BY steps.number",
      [id]
    )
  end

  @doc """
  Returns the list of all steps' full texts and guide ids. Used for searching
  for guides.

  ## Examples

      iex> list_step_guide_ids_and_full_texts()
      [%{guide_id: 1, full_text: "Understand the Coluguide Philosophy"}, ...]

  """
  def list_step_guide_ids_and_full_texts do
    Repo.all(
      from(s in Step,
        select: %{
          guide_id: s.guide_id,
          full_text: s.full_text
        }
      )
    )
  end

  @doc """
  Gets a single step.

  Raises `Ecto.NoResultsError` if the Step does not exist.

  ## Examples

      iex> get_step!(123)
      %Step{}

      iex> get_step!(456)
      ** (Ecto.NoResultsError)

  """
  def get_step!(id), do: Repo.get!(Step, id)

  @doc """
  Gets a step's id by its number and its guide's name.

  Raises `Ecto.NoResultsError` if the Step does not exist.

  ## Examples

      iex> get_step_id_by_number_and_guide_name!(1, "Use Coluguide")
      1

      iex> get_step_id_by_number_and_guide_name!(1, "nonexistent")
      ** (Ecto.NoResultsError)
  """
  def get_step_id_by_number_and_guide_name!(number, guide_name) do
    Repo.one!(
      from s in Step,
        join: g in assoc(s, :guide),
        where: s.number == ^number and g.name == ^guide_name,
        select: s.id
    )
  end

  @doc """
  Creates a step.

  ## Examples

      iex> create_step(%{field: value})
      {:ok, %Step{}}

      iex> create_step(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_step(guide, attrs \\ %{}) do
    guide
    |> Ecto.build_assoc(:steps)
    |> Step.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a step.

  ## Examples

      iex> update_step(step, %{field: new_value})
      {:ok, %Step{}}

      iex> update_step(step, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_step(%Step{} = step, attrs) do
    step
    |> Step.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a step.

  ## Examples

      iex> delete_step(step)
      {:ok, %Step{}}

      iex> delete_step(step)
      {:error, %Ecto.Changeset{}}

  """
  def delete_step(%Step{} = step) do
    Repo.delete(step)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking step changes.

  ## Examples

      iex> change_step(step)
      %Ecto.Changeset{data: %Step{}}

  """
  def change_step(%Step{} = step, attrs \\ %{}) do
    Step.changeset(step, attrs)
  end

  alias Coluguide.Steps.StepImage

  @doc """
  Returns the list of step_images.

  ## Examples

      iex> list_step_images()
      [%StepImage{}, ...]

  """
  def list_step_images do
    Repo.all(StepImage)
  end

  @doc """
  Gets a single step_image.

  Raises `Ecto.NoResultsError` if the Step image does not exist.

  ## Examples

      iex> get_step_image!(123)
      %StepImage{}

      iex> get_step_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_step_image!(id), do: Repo.get!(StepImage, id)

  @doc """
  Creates a step_image.

  ## Examples

      iex> create_step_image(%{field: value})
      {:ok, %StepImage{}}

      iex> create_step_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_step_image(step, attrs \\ %{}) do
    step
    |> Ecto.build_assoc(:step_image)
    |> StepImage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a step_image.

  ## Examples

      iex> update_step_image(step_image, %{field: new_value})
      {:ok, %StepImage{}}

      iex> update_step_image(step_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_step_image(%StepImage{} = step_image, attrs) do
    step_image
    |> StepImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a step_image.

  ## Examples

      iex> delete_step_image(step_image)
      {:ok, %StepImage{}}

      iex> delete_step_image(step_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_step_image(%StepImage{} = step_image) do
    Repo.delete(step_image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking step_image changes.

  ## Examples

      iex> change_step_image(step_image)
      %Ecto.Changeset{data: %StepImage{}}

  """
  def change_step_image(%StepImage{} = step_image, attrs \\ %{}) do
    StepImage.changeset(step_image, attrs)
  end

  alias Coluguide.Steps.DetailsLink

  @doc """
  Returns the list of details_links.

  ## Examples

      iex> list_details_links()
      [%DetailsLink{}, ...]

  """
  def list_details_links do
    Repo.all(DetailsLink)
  end

  @doc """
  Gets a single details_link.

  Raises `Ecto.NoResultsError` if the Details link does not exist.

  ## Examples

      iex> get_details_link!(123)
      %DetailsLink{}

      iex> get_details_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_details_link!(id), do: Repo.get!(DetailsLink, id)

  @doc """
  Gets the names and ids of all guides that have steps that link to the given
  guide_id.

  ## Examples

      iex> get_backlinked_guide_names_and_ids(123)
      [%{name: "Use Coluguide", id: 1}, ...]

  """
  def get_backlinked_guide_names_and_ids(guide_id) do
    rows =
      Repo.query!(
        "SELECT DISTINCT guides.name, guides.id " <>
          "FROM details_links " <>
          "LEFT JOIN steps " <>
          "ON details_links.step_id = steps.id " <>
          "LEFT JOIN guides " <>
          "ON steps.guide_id = guides.id " <>
          "WHERE details_links.guide_id = $1",
        [guide_id]
      ).rows

    Enum.map(rows, fn [name, id] -> %{name: name, id: id} end)
  end

  @doc """
  Creates a details_link.

  ## Examples

      iex> create_details_link(%{field: value})
      {:ok, %DetailsLink{}}

      iex> create_details_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_details_link(step, attrs \\ %{}) do
    step
    |> Ecto.build_assoc(:details_link)
    |> DetailsLink.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a details_link.

  ## Examples

      iex> update_details_link(details_link, %{field: new_value})
      {:ok, %DetailsLink{}}

      iex> update_details_link(details_link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_details_link(%DetailsLink{} = details_link, attrs) do
    details_link
    |> DetailsLink.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a details_link.

  ## Examples

      iex> delete_details_link(details_link)
      {:ok, %DetailsLink{}}

      iex> delete_details_link(details_link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_details_link(%DetailsLink{} = details_link) do
    Repo.delete(details_link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking details_link changes.

  ## Examples

      iex> change_details_link(details_link)
      %Ecto.Changeset{data: %DetailsLink{}}

  """
  def change_details_link(%DetailsLink{} = details_link, attrs \\ %{}) do
    DetailsLink.changeset(details_link, attrs)
  end
end