//
//  ContentView.swift
//  Jersey
//
//  Created by Andy Yu on 2023/3/28.
//

import UIKit


class JerseyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var jerseyImageView: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
}

class JerseyCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var jerseys = [Jersey]()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up collection view
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "JerseyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JerseyCell")
        collectionView.dataSource = self
        // Set up image picker
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
    }
    
    @IBAction func addJersey(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let alertController = UIAlertController(title: "Add Jersey", message: "Enter the team, player, and year for this jersey.", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "Team"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Player"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Year"
            }
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                if let team = alertController.textFields?[0].text, let player = alertController.textFields?[1].text, let year = alertController.textFields?[2].text {
                    let newJersey = Jersey(team: team, player: player, year: year, image: pickedImage)
                    self.jerseys.append(newJersey)
                    self.collectionView.reloadData()
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            picker.dismiss(animated: true, completion: {
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    // MARK: - Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jerseys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JerseyCell", for: indexPath) as! JerseyCollectionViewCell
        cell.jerseyImageView.image = jerseys[indexPath.row].image
        cell.teamLabel.text = jerseys[indexPath.row].team
        cell.playerLabel.text = jerseys[indexPath.row].player
        cell.yearLabel.text = jerseys[indexPath.row].year

        return cell
    }
    
    // MARK: - Collection View Flow Layout
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let cellSize = (collectionView.frame.size.width - padding) / 2
        let cellHeight = cellSize * 1.5
        let cellWidth = cellSize * 0.8 // 新添加的球衣宽度
        let rightPadding = cellSize * 0.2 // 右边留出的空白

        let transform = CGAffineTransform(translationX: -rightPadding, y: 0)
        let transformedSize = CGSize(width: cellWidth, height: cellHeight).applying(transform)

        return transformedSize
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowJerseyDetail" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let destinationVC = segue.destination as! JerseyDetailViewController
                destinationVC.jersey = jerseys[indexPath.row]
            }
        }
    }
}


class JerseyDetailViewController: UIViewController {
    var jersey: Jersey?
    @IBOutlet weak var jerseyImageView: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        jerseyImageView.image = jersey?.image
        teamLabel.text = jersey?.team
        playerLabel.text = jersey?.player
        yearLabel.text = jersey?.year
    }
}





