import pl_bolts.models.autoencoders as bolt
from torch import optim, nn
from conduit.data import CelebADataModule
import pytorch_lightning as pl

import typer

class AE(pl.LightningModule):
    def __init__(self, height: int):
        super().__init__()
        self.encoder = bolt.resnet18_encoder(first_conv=True, maxpool1=False)
        self.decoder = bolt.resnet18_decoder(first_conv=True, maxpool1=False, input_height=height, latent_dim=512)

    def training_step(self, batch, batch_idx):
        # training_step defines the train loop.
        # it is independent of forward
        z = self.encoder(batch.x)
        x_hat = self.decoder(z)
        loss = nn.functional.mse_loss(x_hat, batch.x)
        # Logging to TensorBoard by default
        self.log("train_loss", loss)
        return loss

    def configure_optimizers(self):
        return optim.AdamW(self.parameters(), lr=1e-3)

def main(gpus: int = 1):
    dm = CelebADataModule(root="/storage/data")
    dm.prepare_data()
    dm.setup()
    autoencoder = AE(height=dm.dim_x.h)

    # train the model (hint: here are some helpful Trainer arguments for rapid idea iteration)
    # train on 4 GPUs
    trainer = pl.Trainer(
        limit_train_batches=100,
        max_epochs=1,
        devices=gpus,
        accelerator="gpu",
    )
    trainer.fit(model=autoencoder, datamodule=dm)



if __name__ == "__main__":
    typer.run(main)
