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
      Caption = 'G�n�ral'
      object Memo1: TMemo
        Left = 8
        Top = 8
        Width = 297
        Height = 201
        Lines.Strings = (
          'Le Principe du jeu est d'#39'amener un liquide ( le plasma ) a la '
          'sortie. '
          'Pour y arriver, vous devez construire une canalisation qui '
          'reliera l'#39'entr�e ( en haut a gauche ) et la sortie.'
          'Vous avez a disposition des canalisation ( pieces suivantes ).'
          'Vous pouvez les faire pivoter avec un clic droit sur la piece '
          'ou sur l'#39'aire de jeu.'
          'Vous la poser en faisant un clic gauche.'
          'Le niveau a gauche indique le temps restant avant la mise en '
          'route de la vanne.'
          
            'Le niveau a droite indique le volume de liquide restant a livrer' +
            '.'
          ''
          'Indication : Le plasma ne d�borde que si il ne peut pas couler '
          'vers le bas !')
        ReadOnly = True
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'D�tails'
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
          'Menu d�roulant pour s�lectionner le niveu de d�part. '
          ''
          'Zone Piece suivante :'
          ''
          'Indique la piece qui peut etre pos� sur le jeu.'
          'Elle pivote avec un clic droit.'
          ''
          'Zone Option :'
          ''
          'Superposition : En cochant cette case vous pouvez '
          'remplacer une piece d�j� pos� dans la zone de jeu.'
          ''
          'Zone Vanne :'
          ''
          'D�part : D�lai avant la mise en route des vannes apres '
          'avoir cliqu� sur GO dans controle.'
          'Manuel : Pour ouvrir les vannes avant la fin du d�lai.'
          ''
          'Zone A Propos  :'
          ''
          'Pas de commentaires'
          ''
          'Zone Aide :'
          ''
          'Vous l'#39'avez trouv� ?'
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
