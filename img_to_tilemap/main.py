import numpy as np
import cv2
import os


def get_tile_dif(tile1, tile2):
    dif = cv2.absdiff(tile1, tile2)
    return np.mean(dif)


def find_tile_value( tile, all_tiles):
    tile_value = None
    menor_dif = float("inf")

    for i, tile_conhecido in enumerate(all_tiles):
        dif = get_tile_dif(tile, tile_conhecido)
        if dif < menor_dif:
            tile_value = i
            menor_dif = dif

    return tile_value






self_dir = os.path.dirname(os.path.abspath(__file__))

#por enquanto os tiles vo ser so do mapa depois posso botar de var tmb

arquivo_tiles = os.path.join(self_dir, "tiles_tela_1_novos.png")
altura_tile = largura_tile = 16

all_tiles = []

tiles_img = cv2.imread(arquivo_tiles)
for y in range(0, tiles_img.shape[0], altura_tile):
    for x in range(0, tiles_img.shape[1], largura_tile):
        # Recorte o tile da imagem
        tile = tiles_img[y:y+altura_tile, x:x+largura_tile]
        all_tiles.append(tile)



map_img_dir = "mapa_para_conversao"
tile_map_dir = "mapa_convertido"



img_dir = os.path.join(self_dir, "mapa_para_conversao")
tile_map_dir = os.path.join(self_dir, "mapa_convertido")

if not os.path.exists(map_img_dir):
    os.makedirs(tile_map_dir)

if not os.path.exists(tile_map_dir):
    os.makedirs(tile_map_dir)

for map in os.listdir(map_img_dir):
    if map.endswith(".png"):
        img = cv2.imread(os.path.join(map_img_dir, map))
        tile_map = []

        for y in range(0, img.shape[0], altura_tile):
            linha = []
            for x in range(0, img.shape[1], largura_tile):
                tile = img[y:y+altura_tile, x: x+largura_tile]
                tile_value = find_tile_value(tile, all_tiles)
                linha.append(tile_value)
            tile_map.append(linha)

        tile_map_name = os.path.splitext(map)[0] + "_tilemap.txt"
        tile_path = os.path.join(tile_map_dir, tile_map_name)

        with open(tile_path, 'w') as file:
            for linha in tile_map:
                file_line = ",".join([f"{x}," for x in linha])
                file.write(file_line+",\n")







