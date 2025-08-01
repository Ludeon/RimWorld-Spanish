# This script generates material variations by appending material types
# (like wood, steel, leather, etc.) to a base text input by the user.
# The user can select from different material groups to see the full list.
# Version: 2.0
# Credits: Zerstrick


def add_materials(text):
    # Building materials
    wood = [f"{text} de madera"]
    steel = [f"{text} de acero"]
    silver = [f"{text} de plata"]
    uranium = [f"{text} de uranio"]
    plasteel = [f"{text} de plastiacero"]
    gold = [f"{text} de oro"]
    bioferrite = [f"{text} de bioferrita"]
    obsidian = [f"{text} de obsidiana"]
    sandstone = [f"{text} de arenisca"]
    granite = [f"{text} de granito"]
    limestone = [f"{text} de caliza"]
    slate = [f"{text} de pizarra"]
    marble = [f"{text} de mármol"]
    jade = [f"{text} de jade"]
    voidstone = [f"{text} de vaciorita"]

    # Textiles
    cloth = [f"{text} de tela"]
    light_leather = [f"{text} de cuero ligero"]
    smooth_leather = [f"{text} de cuero liso"]
    patch_leather = [f"{text} de cuero parcheado"]
    synthetic_fabric = [f"{text} de tela sintética"]
    devilstrand = [f"{text} de hilodiablo"]
    hyperweave = [f"{text} de hipertejido"]

    # Wool and furs
    sheep_wool = [f"{text} de lana de oveja"]
    muffalo_wool = [f"{text} de lana de múfalo"]
    megasloth_wool = [f"{text} de lana de megaperezoso"]
    bison_wool = [f"{text} de lana de bisonte"]
    mastodon_wool = [f"{text} de lana de mastodonte"]
    muskox_wool = [f"{text} de lana de buey almizclero"]
    alpaca_wool = [f"{text} de lana de alpaca"]
    trumbo_mane = [f"{text} de crin de trumbo"]

    # Leathers and skins
    bird_skin = [f"{text} de piel de pájaro"]
    dog_leather = [f"{text} de cuero de perro"]
    lizard_leather = [f"{text} de cuero de lagarto"]
    wolf_skin = [f"{text} de piel de lobo"]
    feline_fur = [f"{text} de pelaje felino"]
    fox_fur = [f"{text} de pelaje de zorro"]
    pig_skin = [f"{text} de piel de cerdo"]
    camel_leather = [f"{text} de cuero de camello"]
    bear_skin = [f"{text} de piel de oso"]
    blue_fur = [f"{text} de pelaje azul"]
    elephant_leather = [f"{text} de cuero de elefante"]
    thick_fur = [f"{text} de pelaje grueso"]
    scary_leather = [f"{text} de cuero temible"]
    seal_skin = [f"{text} de piel de pinnípeda"]
    rhino_leather = [f"{text} de cuero de rinoceronte"]
    guinea_pig_fur = [f"{text} de pelaje de cuy"]
    chinchilla_fur = [f"{text} de pelaje de chinchilla"]
    human_leather = [f"{text} de cuero humano"]
    trumbo_fur = [f"{text} de pelaje de trumbo"]
    armadillo_leather = [f"{text} de cuero de armadillo"]
    hippo_leather = [f"{text} de cuero de hipopótamo"]
    mastodon_leather = [f"{text} de cuero de mastodonte"]
    mink_skin = [f"{text} de piel de visón"]

    # Menu for selecting material group
    print("Select a material list:")
    print("1. Core construction materials")
    print("2. All stone and metals")
    print("3. All textiles")
    print("4. Non-leather textiles only")
    choice = input("Enter the number of your choice: ")

    if choice == "1":
        materials = (
            wood + steel + silver + uranium + plasteel + gold + bioferrite + obsidian
        )
    elif choice == "2":
        materials = (
            wood
            + steel
            + sandstone
            + granite
            + limestone
            + slate
            + marble
            + jade
            + silver
            + uranium
            + plasteel
            + gold
            + obsidian
            + bioferrite
            + voidstone
        )
    elif choice == "3":
        materials = (
            cloth
            + light_leather
            + sheep_wool
            + smooth_leather
            + devilstrand
            + synthetic_fabric
            + megasloth_wool
            + muffalo_wool
            + bison_wool
            + mastodon_wool
            + muskox_wool
            + alpaca_wool
            + bird_skin
            + hyperweave
            + patch_leather
            + dog_leather
            + lizard_leather
            + wolf_skin
            + feline_fur
            + fox_fur
            + pig_skin
            + camel_leather
            + bear_skin
            + blue_fur
            + elephant_leather
            + mastodon_leather
            + thick_fur
            + scary_leather
            + seal_skin
            + rhino_leather
            + guinea_pig_fur
            + chinchilla_fur
            + armadillo_leather
            + hippo_leather
            + mink_skin
            + human_leather
            + trumbo_fur
            + trumbo_mane
        )
    elif choice == "4":
        materials = (
            cloth
            + sheep_wool
            + devilstrand
            + synthetic_fabric
            + megasloth_wool
            + muffalo_wool
            + bison_wool
            + mastodon_wool
            + muskox_wool
            + alpaca_wool
            + hyperweave
        )
    else:
        print("Invalid option.")
        return

    # Print result
    print("\nGenerated materials:")
    for m in materials:
        print(m)


# Ask for base name
input_text = input("Enter base name: ")
add_materials(input_text)
