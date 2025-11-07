import UIKit
import Factory
import BluProjectModel

final class HomeViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let footerSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    
    @Injected(\.transferServices) private var transferServices
    @Injected(\.favoriteTransfersService) private var favoriteTransfersService
    
    private var transfers: [Transfer] = []
    
    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupTableView()
        initialLoad()
    }
    
    private func initialLoad() {
        currentPage = 1
        hasMorePages = true
        loadPage(page: currentPage, isRefreshing: false)
    }
    
    private func loadPage(page: Int, isRefreshing: Bool) {
        guard !isLoading && hasMorePages else { return }
        isLoading = true

        if !isRefreshing {
            updateView {
                self.footerSpinner.startAnimating()
            }
        }

        Task {
            do {
                let newTransfers = try await transferServices.fetchContacts(page: page)

                updateView {
                    if isRefreshing {
                        self.transfers = newTransfers
                    } else {
                        self.transfers.append(contentsOf: newTransfers)
                    }

                    self.tableView.reloadData()

                    if newTransfers.isEmpty {
                        self.hasMorePages = false
                    }

                    self.refreshControl.endRefreshing()
                    self.footerSpinner.stopAnimating()
                }
            } catch {
                print("Error fetching page \(page): \(error)")
                await MainActor.run {
                    self.refreshControl.endRefreshing()
                    self.footerSpinner.stopAnimating()
                }
            }

            isLoading = false
        }
    }




    // MARK: - Collection View
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(FavoriteTransferCell.self, forCellWithReuseIdentifier: FavoriteTransferCell.reuseIdentifier)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 110) // story-style height
        ])
    }

    // MARK: - Table View (Below Collection View)
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self

        // Register a simple cell
        tableView.register(TransferTableViewCell.self, forCellReuseIdentifier: TransferTableViewCell.reuseIdentifier)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = footerSpinner

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }
    
    @objc private func refreshData() {
        currentPage = 1
        hasMorePages = true
        loadPage(page: currentPage, isRefreshing: true)
    }


    
    func updateView(_ update: @escaping () -> Void) {
        Task { @MainActor in
            update()
        }
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteTransferCell.reuseIdentifier,
            for: indexPath
        ) as? FavoriteTransferCell else { return UICollectionViewCell() }

        let name = "User \(indexPath.item + 1)"
        let imageURL = "https://randomuser.me/api/portraits/men/\(indexPath.item + 10).jpg"

        cell.configure(name: name, imageURL: imageURL)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 110)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transfers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TransferTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? TransferTableViewCell else { return UITableViewCell() }
        let transfer = transfers[indexPath.row]
        cell.configure(name: transfer.person.fullName, cardNumber: transfer.card.cardNumber, url: transfer.person.avatar)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let thresholdIndex = transfers.count - 3
        if indexPath.row == thresholdIndex && !isLoading && hasMorePages {
            currentPage += 1
            loadPage(page: currentPage, isRefreshing: false)
        }
    }

}
