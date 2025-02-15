/*
 * Hey.com's Pagination controller: https://gist.github.com/dhh/f459dfc3455d2376ce3a7ecb026e6fdf
 */

import {Controller} from "@hotwired/stimulus"
import {request} from "helpers/request_helpers"
import {delay, nextFrame} from "helpers/timing_helpers"

export default class extends Controller {
    static targets = ['nextPageLink', 'nextSection']
    static values = {manualLoad: Boolean, rootMargin: String}

    initialize() {
        this.observeNextPageLink()
    }

    async loadNextPage(event) {
        event?.preventDefault()

        this.element.setAttribute('aria-busy', 'true')

        const html = await this.loadNextPageHTML()
        await nextFrame()
        this.element.setAttribute('aria-busy', 'false')
        this.nextSectionTarget.outerHTML = html

        await delay(500)
        this.observeNextPageLink()
    }

    // Private

    async observeNextPageLink() {
        if (this.manualLoadValue) return

        await nextFrame()
        const {nextPageLink, intersectionOptions} = this
        if (!nextPageLink) return

        if (nextPageLink.dataset.preload == 'true') {
            this.loadNextPage()
        } else {
            await nextIntersection(nextPageLink, intersectionOptions)
            this.loadNextPage()
        }
    }

    async loadNextPageHTML() {
        const html = await request.get(this.nextPageLink.href)
        const doc = new DOMParser().parseFromString(html, 'text/html')
        const selector = this.element.id
            ? `#${this.element.id}`
            : `[data-controller~="${this.identifier}"]`
        const element = doc.querySelector(selector)

        if (!element) return ''

        // Ensure no duplicate rows are added
        const rows = element.querySelectorAll('tr')
        const existingRows = this.element.querySelectorAll('tr')
        const existingRowIds = Array.from(existingRows).map((row) => row.id)
        rows.forEach((row) => {
            if (!!row.id && existingRowIds.includes(row.id)) {
                row.remove()
            }
        })

        return element.innerHTML.trim()
    }

    get nextPageLink() {
        const links = this.nextPageLinkTargets
        if (links.length > 1) console.warn('Multiple next page links', links)
        return links[links.length - 1]
    }

    get intersectionOptions() {
        const options = {
            root: this.scrollableOffsetParent,
            rootMargin: this.rootMarginValue,
        }
        for (const [key, value] of Object.entries(options)) {
            if (value) continue

            delete options[key]
        }

        return options
    }

    get scrollableOffsetParent() {
        const root = this.element.offsetParent
        return root && root.scrollHeight > root.clientHeight ? root : null
    }
}

function nextIntersection(element, options = {}) {
    return new Promise((resolve) => {
        new IntersectionObserver(([entry], observer) => {
            if (!entry.isIntersecting) return
            observer.disconnect()
            resolve()
        }, options).observe(element)
    })
}
