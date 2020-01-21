# Maintainer: Ciaran Moran <ciaran.moran@linaro.org>
# Contributor: Steve Engledow <steve@engledow.me>
pkgname=aws-cli-v2
pkgver=2.0.0dev3
pkgrel=1
pkgdesc="Experimental v2 of the AWS CLI"
arch=('x86_64')
url="https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html"
license=('Apache-2.0')
depends=(
)
makedepends=(
  'unzip'
)
source=(
  "awscliv2.zip.sig::https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-${arch}.zip.sig"
  "awscliv2.zip::https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-${arch}.zip"
)
sha1sums=(
  'SKIP'
  'SKIP'
)
validpgpkeys=('FB5DB77FD5C118B80511ADA8A6310ACC4672475C')

package() {
  ./aws/install -i "${pkgdir}/opt/${pkgname}" -b "${pkgdir}/tmp"
  rm -fr "${pkgdir}/tmp"
  cd "${pkgdir}"
  mkdir -p "${pkgdir}/usr/bin"
  ln -s "/opt/${pkgname}/v2/current/bin/aws2" "${pkgdir}/usr/bin/aws2"
  ln -s "/opt/${pkgname}/v2/current/bin/aws2_completer" "${pkgdir}/usr/bin/aws2_completer"
  cd "${pkgdir}/opt/aws-cli-v2/v2"
  rm -fr "${pkgdir}/opt/aws-cli-v2/v2/current"
  ln -s "${pkgver}" "${pkgdir}/opt/aws-cli-v2/v2/current"
}
