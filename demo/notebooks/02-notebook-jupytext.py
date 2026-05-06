# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: py:percent
#     text_representation:
#       extension: .py
#       format_name: percent
#   kernelspec:
#     display_name: Python 3 (ipykernel)
#     language: python
#     name: python3
#   language_info:
#     name: python
#     nbconvert_exporter: python
#     pygments_lexer: ipython3
# ---

# %% [markdown]
# # jupytext

# %% [markdown]
# on peut sauver les notebooks dans un format `.py` plutôt que le format natif `.ipynb`
#
# avantages:
#
# 1. se prête beaucoup mieux à la gestion de version (git)
# 1. on peut exécuter le fichier directement avec `python lefichier.py`
# 1. et si il faut, on peut aussi l'exécuter dans vscode
#
# le seul inconvénient par rapport à un `.ipynb` est qu'on ne peut pas sauver la valeur de sortie des cellules une fois qu'elles sont évaluées

# %% [markdown]
# # installation

# %% [markdown]
# on l'a **déjà fait pendant les installations**, mais:
#
# ````{admonition} pour mémoire
# :class: dropdown
# - comme toujours on installe ça avec 
#   ```bash
#   pip install jupytext
#   ```
# - et aussi, pas indispensable, mais plus pratique (un peu plus bas, on explique à quoi ça sert)
#   ```bash
#   jupytext-config set-default-viewer
#   ```
# ````

# %%
print("je suis un notebook en jupytext")

# %% [markdown]
# **exercice 1**
#
# ouvrez ce notebook dans jupyter lab; il doit apparaitre comme un notebook, et non pas comme un simple fichier `.py`
#
# ```{admonition} plusieurs façons
# :class: dropdown
#
# pour ouvrir un fichier dans jlab:
# * à partir de l'outil *file browser* (en haut à gauche)
# * vous pouvez soit:
#   * faire un click droit → *Open With* → *Notebook*
#     si vous avez installé `jupytext`, cette méthode marche toujours  
#   * ou, plus rapide, double-cliquer le fichier  
#     mais pour que cela fonctionne, il vous avoir fait le `jupytext-config ...` 
# ```

# %% [markdown]
# **exercice 2**
#
# toujours dans jupyter, exécutez le code ci-dessous, et sauvez le notebook  
# ouvrez alors le fichier dans vs-code et vérifiez que la sortie (notamment la courbe) ne sont pas sauvées dans le fichier

# %%
import numpy as np
import matplotlib.pyplot as plt

# %matplotlib ipympl

X = np.linspace(-5, 5)
Y = X**3
plt.plot(X, Y);
