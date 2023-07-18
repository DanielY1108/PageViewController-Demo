//
//  TutorialViewController.swift
//  PageViewController-Demo
//
//  Created by JINSEOK on 2023/07/17.
//

import UIKit
import SnapKit

// 현재 주석처리 된 부분은 DataSource를 사용하여 indicator를 적용하는 방법 입니다. (코드 74번 째 줄 참고)

class TutorialViewController: UIPageViewController {
    
    private var skipButton: UIButton!
    private var nextButton: UIButton!
    
    private var pages = [UIViewController]()
    private var initialPage = 0
    
    private var pageControl: UIPageControl!
    
    private var nextButtonTopConstraint: Constraint!
    private var skipButtonTopConstraint: Constraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPage()
        setupUI()
        setupLayout()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        for view in view.subviews {
//            if view is UIScrollView {
//                // UIPageViewController의 뷰를 끝까지 확장 (UIPageViewController 내부는 UIScrollView로 구성 됨)
//                view.frame = UIScreen.main.bounds
//
//            } else if view is UIPageControl {
//                let pageControl = (view as? UIPageControl)
//                pageControl?.isUserInteractionEnabled = false
//                pageControl?.currentPageIndicatorTintColor = .red
//                pageControl?.pageIndicatorTintColor = .lightGray
//                pageControl?.backgroundColor = .systemBackground
//            }
//        }
//    }
    
    private func setupPage() {
        let page1 = PageContentsViewController(imageName: "page1",
                                               title: "검색",
                                               subTitle: "여기서 지역을 검색할 수 있습니다. 자유롭게 검색해보세요")
        let page2 = PageContentsViewController(imageName: "page2",
                                               title: "지도",
                                               subTitle: "지도를 통해 검색된 위치를 확인해보세요")
        let page3 = PageContentsViewController(imageName: "page3",
                                               title: "설정창",
                                               subTitle: "여기는 설정창입니다")
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
    }
    
    private func setupUI() {
        // ⭐️ dataSource 화면에 보여질 뷰컨트롤러들을 관리합니다 ⭐️
        self.dataSource = self
        self.delegate = self
        // UIPageViewController에서 처음 보여질 뷰컨트롤러 설정 (첫 번째 page)
        self.setViewControllers([pages[initialPage]], direction: .forward, animated: true)
        
        // DataSource 값을 설정해주면, 자동으로 UIPageControl 적용이 됩니다. (presentationIndex, presentationCount)
        // 그런데 UIPageViewController 속성에 UIPageControl가 없으므로 디자인을 바꾸려면, 아래와 같은 방법으로 바꿔줄 수 있다.
        // 방법 1. UIPageControl의 전역으로 UI 설정 (앱에서 사용되는 모든 UIPageControl의 UI를 바꾼다면, appearance로 사용해도 됨)
        // 방법 2. viewDidLayoutSubviews의 서브뷰로 접근해서 설정 (코드 28번 째 줄)
//        pageControl = UIPageControl.appearance()
//        pageControl.currentPageIndicatorTintColor = .red
//        pageControl.pageIndicatorTintColor = .lightGray
//        pageControl.backgroundColor = .systemBackground
        
        // 직접 만들어 사용도 가능한데, 변하는 값들을 직접 구현해줘야 한다.
        pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.backgroundColor = .systemBackground
        pageControl.addTarget(self, action: #selector(pageControlHandler), for: .valueChanged)
        
        // 버튼 UI 설정
        skipButton = UIButton()
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.systemBlue, for: .normal)
        skipButton.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
        
        nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            nextButtonTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide).constraint
            $0.trailing.equalToSuperview().offset(-20)
        }

        view.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            skipButtonTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide).constraint
            $0.leading.equalToSuperview().offset(20)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - DataSource

extension TutorialViewController: UIPageViewControllerDataSource {
    // 이전 뷰컨트롤러를 리턴 (우측->좌측 슬라이드 제스쳐)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 현재 VC의 인덱스를 구합니다.
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        guard currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }
    
    // 다음 보여질 뷰컨트롤러를 리턴 (좌측->우측 슬라이드 제스쳐)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        guard currentIndex < (pages.count - 1) else { return nil }
        return pages[currentIndex + 1]
    }

    // 인디케이터(pageControl)의 총 개수
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return pages.count
//    }
//
//    // 인디케이터(pageControl)에 반영할 값 (pageControl.currentPage라고 생각하면 된다)
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        guard let viewController = pageViewController.viewControllers?.first,
//              let currentIndex = pages.firstIndex(of: viewController) else { return 0 }
//
//        return currentIndex
//    }
}

// MARK: - Delegate

extension TutorialViewController: UIPageViewControllerDelegate {
    
    // UIPageViewController의 델리게이트를 사용해 UIPageControl의 현재 페이지를 업데이트 시킴
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let viewControllers = pageViewController.viewControllers,
              let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }

        pageControl.currentPage = currentIndex
        animateButtonLayoutIfNeeded()
    }
}

// MARK: - Action

extension TutorialViewController {
    
    @objc func buttonHandler(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Skip":
            UserDefaults.standard.set(true, forKey: "Tutorial")
            dismiss(animated: true)
        case "Next":
            goToNextPage()
            pageControl.currentPage += 1
 
        default: break
        }
        
        animateButtonLayoutIfNeeded()
    }
    
    // 페이지 컨트롤을 움직이면, 페이지를 표시 해줌
    @objc func pageControlHandler(_ sender: UIPageControl) {
        guard let currnetViewController = viewControllers?.first,
              let currnetIndex = pages.firstIndex(of: currnetViewController) else { return }
        
        // 코드의 순서 상 페이지의 인덱스보다 pageControl의 값이 먼저 변한다.
        // 그러므로, currentPage가 크면 오른쪽 방향, 작으면 왼쪽 방향으로 움직이게 설정해 줌
        let direction: UIPageViewController.NavigationDirection = (sender.currentPage > currnetIndex) ? .forward : .reverse
        self.setViewControllers([pages[sender.currentPage]], direction: direction, animated: true)
    }
}

// MARK: - Extension

extension TutorialViewController {
    // 다음 페이지로 이동하기
    func goToNextPage() {
        // UIPageViewController에는
        guard let currentPage = viewControllers?[0],
              let nextPage = self.dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        self.setViewControllers([nextPage], direction: .forward, animated: true)
    }
    
    // 이전 페이지로 이동하기
    func goToPreviousPage() {
        guard let currentPage = viewControllers?[0],
              let previousPage = self.dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        self.setViewControllers([previousPage], direction: .reverse, animated: true)
    }
    
    // 특정 페이지로 이동하기
    func goToSpecificPage(index: Int) {
        self.setViewControllers([pages[index]], direction: .forward, animated: true)
    }
    
    // 버튼이 사라지고 나타나는 애니메이션 효과
    private func animateButtonLayoutIfNeeded() {
        if pageControl.currentPage == (pages.count - 1) {
            hideButtons()
        } else {
            showButtons()
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: .zero, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func showButtons() {
        skipButtonTopConstraint.update(offset: 0)
        nextButtonTopConstraint.update(offset: 0)
    }
    
    private func hideButtons() {
        skipButtonTopConstraint.update(offset: -100)
        nextButtonTopConstraint.update(offset: -100)
    }
}
