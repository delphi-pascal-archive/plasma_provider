object frmAide: TfrmAide
  Left = 384
  Top = 216
  BorderStyle = bsToolWindow
  Caption = 'Aide'
  ClientHeight = 256
  ClientWidth = 321
  Color = clGrayText
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 321
    Height = 241
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Général'
      object Memo1: TMemo
        Left = 8
        Top = 8
        Width = 297
        Height = 201
        Lines.Strings = (
          'Le Principe du jeu est d'#39'amener un liquide ( le plasma ) a la '
          'sortie. '
          'Pour y arriver, vous devez construire une canalisation qui '
          'reliera l'#39'entrée ( en haut a gauche ) et la sortie.'
          'Vous avez a disposition des canalisation ( pieces suivantes ).'
          'Vous pouvez les faire pivoter avec un clic droit sur la piece '
          'ou sur l'#39'aire de jeu.'
          'Vous la poser en faisant un clic gauche.'
          'Le niveau a gauche indique le temps restant avant la mise en '
          'route de la vanne.'
          
            'Le niveau a droite indique le volume de liquide restant a livrer' +
            '.'
          ''
          'Indication : Le plasma ne déborde que si il ne peut pas couler '
          'vers le bas !')
        ReadOnly = True
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Détails'
      ImageIndex = 1
      object Memo2: TMemo
        Left = 8
        Top = 16
        Width = 297
        Height = 193
        Lines.Strings = (
          'Zone Controle :'
          ''
          'Bouton Go pour lancer le jeu.'
          'Stop Pour arreter.'
          'Menu déroulant pour sélectionner le niveu de départ. '
          ''
          'Zone Piece suivante :'
          ''
          'Indique la piece qui peut etre posé sur le jeu.'
          'Elle pivote avec un clic droit.'
          ''
          'Zone Option :'
          ''
          'Superposition : En cochant cette case vous pouvez '
          'remplacer une piece déjà posé dans la zone de jeu.'
          ''
          'Zone Vanne :'
          ''
          'Départ : Délai avant la mise en route des vannes apres '
          'avoir cliqué sur GO dans controle.'
          'Manuel : Pour ouvrir les vannes avant la fin du délai.'
          ''
          'Zone A Propos  :'
          ''
          'Pas de commentaires'
          ''
          'Zone Aide :'
          ''
          'Vous l'#39'avez trouvé ?'
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Button1: TButton
    Left = 0
    Top = 240
    Width = 321
    Height = 17
    Caption = 'Fermer'
    TabOrder = 1
    OnClick = Button1Click
  end
end
