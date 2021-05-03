# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HappyTree.Repo.insert!(%HappyTree.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

HappyTree.Repo.insert!(%HappyTree.Plants.Plant{common_name: "Sunflower", slug: "sunflower"})
